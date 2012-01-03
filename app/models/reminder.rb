class Reminder < ActiveRecord::Base
  belongs_to :call
  belongs_to :conference

  validates_presence_of :email
  validates_presence_of :offset
  validates_presence_of :send_day

end
