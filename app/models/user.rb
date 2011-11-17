class User < ActiveRecord::Base
  has_and_belongs_to_many :publications

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
    return((rolemask & (RoleCoordinator | RoleManager | RoleOffice)) > 0) if model_id == 5

    true
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
