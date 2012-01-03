class Call < ActiveRecord::Base
  belongs_to :conference
  belongs_to :journal
  belongs_to :book
  has_many :publications
  has_many :reminders

  validates_presence_of :deadline
  validates_presence_of :url

  DefaultReminderOffset = 7

  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:call_for,         :source,          Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:deadline,         :deadline,        Sortable::C_Default, Sortable::C_Default),
    Sortable::HeaderInfo.new(:webpage,          :url,             Sortable::C_No,      Sortable::C_No     ),
    Sortable::HeaderInfo.new(:guest_editor,     :guest_editor,    Sortable::C_No,      Sortable::C_No     )]

  def default_reminder(attr, user)
    if attr == :deadline
      Reminder.new(:call_id => self[:id], :attribute_name => 'deadline', :offset => DefaultReminderOffset, :send_day => deadline - DefaultReminderOffset, :email => user.email)
    else
      nil
    end
  end
end
