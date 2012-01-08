class Call < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  has_many :publications
  has_many :reminders

  validates_presence_of :deadline
  validates_presence_of :url
  validates_format_of :url, :with => URI::regexp(%w{http https})

  DefaultReminderOffset = 7

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:call_for,         :source,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:deadline,         :deadline,        Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:guest_editor,     :guest_editor,    Sortable::C_No,      Sortable::C_No     )]

  def validate
    if ! (book_id || conference_id || journal_id)
      errors[:conference_id] << errors.generate_message(:conference_id, :source_missing) 
    end
  end

  def default_reminder(attr, user)
    if attr == :deadline
      Reminder.new(:call_id => self[:id], :attribute_name => 'deadline', :offset => DefaultReminderOffset, :send_day => deadline - DefaultReminderOffset, :email => user.email)
    else
      nil
    end
  end

  def display_name
    if self[:conference_id]
      "#{self.conference.display_name}, #{deadline}"
    elsif self[:journal_id]
      "#{self.journal.display_name}, #{deadline}"
    elsif self[:book_id]
      "#{self.book.display_name}, #{deadline}"
    else
      deadline.to_s
    end
  end

  def select_name
    display_name
  end

  def scope_string
    if self[:book_id]
      book.display_name
    elsif self[:journal_id]
      journal.display_name
    elsif self[:conference_id]
      conference.display_name
    else
      ""
    end
  end

  def self.in_future
    Call.find(:all, :conditions => "deadline > '#{Date.today.to_s(:db)}'")
  end
end
