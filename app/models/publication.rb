class Publication < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  belongs_to :call
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :users

  validates_presence_of :title

  include Sortable

  CodePrime = 5915587277  # this should be a prime
  CodeMultiplier = 9576890767

  DisplayInfo = [
    Sortable::HeaderInfo.new(:authors,          :authors,         Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:title,            :title,           Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:status,           :status,          Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:source,           :source,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:volume,           :volume,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:number,           :number,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:year,             :year,            Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:pages,            :pages,           Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:doi,              :doi,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:abstract,         :abstract,        Sortable::C_No,      Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:pdf_link,         :pdf,             Sortable::C_No,      Sortable::C_No     )
  ]

  # Possible status values
  class StatusValues
    None = 0
    Idea = 1
    IdeaAccepted = 2
    Written  = 3
    PendingSubmission = 4
    Submitted = 5
    Accepted = 6
    Published = 7
    Withdrawn = 8

    # display names of the statuses
    Names = {1 => :status_idea, 2 => :status_idea_accepted, 3 => :status_written, 4 => :status_pending_submission, 5 => :status_submitted, 6 => :status_accepted, 7 => :status_published, 8 => :status_withdrawn}

    def self.content_writeable?(val)
      [None, Idea, IdeaAccepted, Written, PendingSubmission].include?(val.to_i)
    end

    def self.content_active?(val)
      [None, Idea, IdeaAccepted, Written, PendingSubmission, Submitted, Accepted, Published].include?(val.to_i)
    end

    # returns a pair usable for option_for_select
    def self.select_pair(val)
      val = StatusValues.norm_val(val)
      [StatusValues.get_name(val), val]
    end

    def self.get_name(val)
      return Names[StatusValues.norm_val(val)]
    end

    # normalize value
    def self.norm_val(val)
      norm_val = [[val.to_i, Idea].max, Withdrawn].min
    end

    def self.to_withdrawn(val)
      val < Withdrawn ? val + Withdrawn : val
    end

    def self.remove_withdrawn(val)
      val >= Withdrawn ? val - Withdrawn : val
    end

    # checks if new status is reachable from old status and return new status or nil
    def self.check_new_status(old_status, new_status)
      if new_status == Withdrawn
        if old_status >= Withdrawn
          old_status
        else
          old_status + Withdrawn
        end
      elsif new_status > 0 && new_status < Withdrawn
        (old_status - new_status).abs < 2 ?  new_status : nil
      else
        nil
      end
    end

    def self.withdrawn?(val)
      val >= Withdrawn
    end
  end

  # Check if the given attribute is editable by the given user
  def editable?(attr_name, the_user)
    return false unless user_valid?(the_user) # only owners and users with special rights may edit publications
    
    case attr_name
    when :title, :abstract
      StatusValues.content_writeable?(self[:status])
    when :conference_id, :journal_id, :book_id, :call_id
      StatusValues.content_writeable?(self[:status])
    when :pdf, :doi, :pages, :volume, :number, :year
      StatusValues.content_active?(self[:status])
    when :status
      false # status changes are checked by a different logic
    when :history
      false # unused at the moment
    else
      false
    end
  end

  # Check if the user has the rights on this document
  def user_valid?(the_user)
    user_ids = users.map {|a_user| a_user.id}
    return true if user_ids.empty?  # publication not saved yet - fully readable
    return true if user_ids.include?(the_user.id) # The user is owner of the publication

    # check for special privileges
    return the_user.is_manager? || the_user.is_coordinator?
  end

  # Returns user relation to the document.
  # This returns a pair [user_is_owner, user_is_admin]
  def user_relation(the_user)
    result = [false, false]
    author_ids = authors.map {|auth| auth.id}
    result[0] = true if author_ids.empty?  # publication not saved yet - fully readable
    result[0] = true if author_ids.include?(the_user[:author_id]) # The user is owner of the publication

    # check for special privileges
    result[1] = (the_user.is_manager? || the_user.is_coordinator?)

    result
  end

  # possible status changes for this document and user in a format usable for options_for_select
  def status_changes(the_user)
    result = []
    is_owner, is_manager = user_relation(the_user)

    if is_owner || is_manager
      case StatusValues.norm_val(self[:status])
      when StatusValues::Idea
        result << StatusValues.select_pair(StatusValues::IdeaAccepted) if is_manager
        result << StatusValues.select_pair(StatusValues::Withdrawn) unless self[:status].nil?
      when StatusValues::IdeaAccepted
        result << StatusValues.select_pair(StatusValues::Idea) if is_manager
        result << StatusValues.select_pair(StatusValues::Written) if is_owner && !pdf.blank?
        result << StatusValues.select_pair(StatusValues::Withdrawn)
      when StatusValues::Written
        result << StatusValues.select_pair(StatusValues::PendingSubmission) if is_manager
        result << StatusValues.select_pair(StatusValues::IdeaAccepted)
        result << StatusValues.select_pair(StatusValues::Withdrawn)
      when StatusValues::PendingSubmission
        result << StatusValues.select_pair(StatusValues::Submitted) if is_owner
        result << StatusValues.select_pair(StatusValues::Written)
        result << StatusValues.select_pair(StatusValues::Withdrawn)
      when StatusValues::Submitted
        result << StatusValues.select_pair(StatusValues::Accepted) if is_owner
        result << StatusValues.select_pair(StatusValues::PendingSubmission)
        result << StatusValues.select_pair(StatusValues::Withdrawn)
      when StatusValues::Accepted
        result << StatusValues.select_pair(StatusValues::Published) if is_owner
        result << StatusValues.select_pair(StatusValues::Submitted)
        result << StatusValues.select_pair(StatusValues::Withdrawn)
      when StatusValues::Withdrawn
        result << StatusValues.select_pair(StatusValues.remove_withdrawn(self[:status]))
      end
    end

    result
  end

  def status_name
    StatusValues.get_name(StatusValues.norm_val(self[:status]))
  end

  def pdf_name
    "pdf/publication_#{coded_id}.pdf"
  end

  def withdrawn?
    StatusValues.withdrawn?(self[:status])
  end

  # savely change to new status
  def check_new_status(new_status)
    real_status =  StatusValues.check_new_status(self[:status], new_status)
    if real_status
      self[:status] = real_status
      true
    else
      false
    end
  end

  private

  def coded_id
    (self[:id] * CodeMultiplier) % CodePrime
  end
end
