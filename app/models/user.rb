require 'ldap'

class User < ActiveRecord::Base
  has_and_belongs_to_many :publications
  belongs_to :author

  validates_uniqueness_of :name

  # Constants for Author creation from user
  DefaultAffiliation = "AIT"

  # Constants for LDAP
  LDAP_Server = "10.100.5.200"
  LDAP_Base = 'ou=Users,ou=Arsenal Research,dc=D01,dc=arc,dc=local'
  LDAP_Port = 389
  LDAP_Domain = "D01.arc.local"

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
      (! item.withdrawn?) && item.user_valid?(self)
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

  # Authentication procedure. Proper password protection not implemented yet
  def self.authenticate(name, password)
    user = self.find_by_name(name)
    name_re = Regexp.new("[/\\\\]") # used to split login name into domain and name part

    begin
      ldap_conn = LDAP::Conn.new(LDAP_Server, LDAP_Port)
      ldap_conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
      ldap_conn.bind(name, password) do |conn|
        unless user
          user = User.create({:name => name, :rolemask => 0})
        end

        if user
          nr_entries = 0
          
          main_name = name.split(name_re).last

          info_list = conn.search(LDAP_Base, LDAP::LDAP_SCOPE_SUBTREE, "(userPrincipalName=#{main_name}@#{LDAP_Domain})") do |entry|
            nr_entries += 1

            ldap_first_name = (entry.vals('givenName') || [])[0]
            ldap_last_name = (entry.vals('sn') || [])[0]
            ldap_email = (entry.vals('mail') || [])[0]

            # check author information
            if user.author.nil?
              the_author = Author.new({:affiliation => DefaultAffiliation, :first_name => ldap_first_name, :last_name => ldap_last_name})
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

    # debug version
    # if user
    #   user = nil unless password == 'Flea'
    # end

    user
  end

  def self.all_coordinators
    self.find(:all, :conditions => ['rolemask & :role', {:role => RoleCoordinator}])
  end
end
