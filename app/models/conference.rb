class Conference < ActiveRecord::Base
  has_many :calls
  has_many :publications
  has_many :reminders

  validates_presence_of :name
  validates_presence_of :location
  validates_presence_of :url
  validates_presence_of :begin_date
  validates_presence_of :end_date
  validates_presence_of :deadline
  validates_presence_of :acceptance
  validates_presence_of :due
  validates_presence_of :submission_type
  validates_presence_of :proceedings

  include Sortable

  DefaultReminderDeadlineOffset = 7
  DefaultReminderDueOffset = 0

  DisplayInfo = [
    Sortable::HeaderInfo.new(:name,             :name,            Sortable::C_Default, Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:location,         :location,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:begin_date,       :begin_date,      Sortable::C_Yes,     Sortable::C_Default),
    Sortable::HeaderInfo.new(:end_date,         :end_date,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:deadline,         :deadline,        Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:acceptance,       :acceptance,      Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:due,              :due,             Sortable::C_Yes,     Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:submission_type,  :submission_type, Sortable::C_No,      Sortable::C_Yes    ),
    Sortable::HeaderInfo.new(:title_proceed,    :proceedings,     Sortable::C_Yes,     Sortable::C_Yes    )]

  def validate
    errors[:end_date] << errors.generate_message(:end_date, :conflict_begin_date) if begin_date > end_date
    errors[:deadline] << errors.generate_message(:deadline, :conflict_begin_date) if deadline > begin_date
    errors[:acceptance] << errors.generate_message(:acceptance, :conflict_deadline) if deadline > acceptance
    errors[:due] << errors.generate_message(:due, :conflict_acceptance) if acceptance < due
  end

  def display_name
    name
  end

  def select_name
    name
  end

  def default_reminder(attr, user)
    case attr
    when :deadline
      Reminder.new(:conference_id => self[:id], :attribute_name => attr.to_s, :offset => DefaultReminderDeadlineOffset, :send_day => deadline - DefaultReminderDeadlineOffset, :email => user.email)
    when :due
      Reminder.new(:conference_id => self[:id], :attribute_name => attr.to_s, :offset => DefaultReminderDueOffset, :send_day => deadline - DefaultReminderDueOffset, :email => user.email)
    else
      nil
    end
  end

  def self.in_future
    Conference.find(:all, :conditions => "begin_date > '#{Date.today.to_s(:db)}'")
  end
end
