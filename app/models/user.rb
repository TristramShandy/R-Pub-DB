require 'ldap'

class User < ActiveRecord::Base
  has_and_belongs_to_many :publications
  belongs_to :author

  validates_uniqueness_of :name

  # Role constants - Each role corresponds to one bit of the integer
  RoleCoordinator = 1
  RoleManager = 4
  RoleOffice = 2

  def is_coordinator?
    (rolemask & RoleCoordinator) == RoleCoordinator
  end

  def is_manager?
    (rolemask & RoleManager) == RoleManager
  end

  def is_office?
    (rolemask & RoleOffice) == RoleOffice
  end

  def may_see_model?(model_id)
    # Old version: use this if you want to open users to view
    # user lists may only be seen by special roles
    # return((rolemask & (RoleCoordinator | RoleManager | RoleOffice)) > 0) if model_id == 6
    # true
    
    # Users can not be seen
    model_id != 6
  end

  def may_edit?(item)
    case item
    when Book
      true
    when Journal
      true
    when Conference
      true
    when Publication
      item.user_valid?(self)
    when Call
      true
    when Reminder
      false
    else
      true
    end
  end

  def may_delete?(item)
    case item
    when Author
      item.publications.empty? && item.books.empty? && item[:user_id].nil?
    when Book
      item.publications.empty? && item.calls.empty?
    when Conference
      item.publications.empty? && item.calls.empty?
    when Journal
      item.publications.empty? && item.calls.empty?
    when Publication
      item.withdrawn? && item.user_valid?(self)
    when Call
      true
    when Reminder
      item.email == email
    else
      false
    end
  end

  def valid_publications
    if is_office? || is_manager? || is_coordinator?
      Publication.all
    else
      the_author = author
      the_author ? the_author.publications : []
    end
  end

  def valid_reminders
    Reminder.find(:all, :conditions => ['send_day >= :today and email = :email', {:today => Date.today, :email => email}])
  end

  # Authentication procedure. Proper password protection not implemented yet
  def self.authenticate(name, password)
    user = nil
    name_re = Regexp.new("[/\\\\]") # used to split login name into domain and name part

    if Rails.env != 'production' && ENV['DEBUG_RAILS'] == 'noldap'
      # debug version
      user = self.find_by_name(name)
      if user
        user = nil unless password == 'Flea'
      end
    else
      begin
        ldap_conn = LDAP::Conn.new(APP_CONFIG["organization"]["ldap_server"], APP_CONFIG["organization"]["ldap_port"])
        ldap_conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
        ldap_conn.bind(name, password) do |conn|
          user = self.find_by_name(name)
          unless user
            user = User.create({:name => name, :rolemask => 0})
          end

          if user
            nr_entries = 0

            main_name = name.split(name_re).last

            info_list = conn.search(APP_CONFIG["organization"]["ldap_base"],
                                    LDAP::LDAP_SCOPE_SUBTREE,
                                    "(#{APP_CONFIG["organization"]["ldap_attribute_principal_name"]}=#{main_name}@#{APP_CONFIG["organization"]["ldap_domain"]})"
                                   ) do |entry|
              nr_entries += 1

              ldap_first_name = (entry.vals(APP_CONFIG["organization"]["ldap_attribute_first_name"]) || [])[0]
              ldap_last_name = (entry.vals(APP_CONFIG["organization"]["ldap_attribute_last_name"]) || [])[0]
              ldap_email = (entry.vals(APP_CONFIG["organization"]["ldap_attribute_email"]) || [])[0]

              # check author information
              if user.author.nil?
                the_author = Author.new({:affiliation => APP_CONFIG["organization"]["affiliation"], :first_name => ldap_first_name, :last_name => ldap_last_name})
                if the_author.save
                  user[:author_id] = the_author.id
                  user.save
                end
              end

              # verify user email information
              if ldap_email && user.email != ldap_email
                user.email = ldap_email
                user.save
              end
            end

            if nr_entries == 0
              logger.warn("User #{name} does not have an LDAP entry")
            elsif nr_entries > 1
              logger.warn("User #{name} does have multiple LDAP entries")
            end
          end
        end
      rescue LDAP::ResultError
        logger.warn("User.authenticate created LDAP::ResultError")
      end
    end

    user
  end

  def name_and_role
    str = ""
    the_author = self.author
    if the_author
      str = author.display_name
    else
      str = self.name
    end

    str += ", #{I18n.t :office}" if is_office?
    str += ", #{I18n.t :coordinator}" if is_coordinator?
    str += ", #{I18n.t :manager}" if is_manager?

    str
  end

  def self.all_coordinators
    self.find(:all, :conditions => ['rolemask & :role', {:role => RoleCoordinator}])
  end
end
