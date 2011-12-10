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
    # user lists may only be seen by special roles
    return((rolemask & (RoleCoordinator | RoleManager | RoleOffice)) > 0) if model_id == 6

    true
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
      is_manager? || is_coordinator? || is_office? || (item.publications.empty? && item.books.empty? && item[:user_id].nil?)
    when Book
      is_manager? || is_coordinator? || is_office?
    when Journal
      is_manager? || is_coordinator? || is_office?
    when Conference
      is_manager? || is_coordinator? || is_office?
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
  # TODO: implement
  def self.authenticate(name, password)
    user = self.find_by_name(name)

    if user
      user = nil unless password == 'Flea'
    end
    user
  end

  def self.all_coordinators
    self.find(:all, :conditions => ['rolemask & :role', {:role => RoleCoordinator}])
  end
end
