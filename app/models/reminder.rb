class Reminder < ActiveRecord::Base
  belongs_to :call
  belongs_to :conference

  validates_presence_of :email
  validates_presence_of :offset
  validates_presence_of :send_day


  include Sortable

  DisplayInfo = [
    Sortable::HeaderInfo.new(:reminder_source,  :reminder_source,    Sortable::C_Yes,     Sortable::C_Default),
    Sortable::HeaderInfo.new(:send_day,         :send_day,           Sortable::C_Default, Sortable::C_Yes    )]

  def display_name
    remincer_source
  end

  def reminder_source
    str = ""
    if self.conference
      str = "#{conference.display_name}, #{I18n.t(attribute_name.to_sym)}"
    elsif self.call
      str = call.display_name
    else
      return I18n.t(:illegal_reminder)
    end

    if offset > 0
      str += " -#{offset} #{I18n.t(:days, :count => offset)}"
    end

    str
  end

  # numeric id of scope
  def scope
    if self[:conference_id]
      0
    elsif self[:call_id]
      4
    else
      4 # default is reminder for call
    end
  end
end
