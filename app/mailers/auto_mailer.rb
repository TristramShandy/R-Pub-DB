class AutoMailer < ActionMailer::Base

  # sends the info of a new idea to all coordinators
  def new_idea(a_publication, a_coordinator)
    @publication = a_publication
    mail(:to => a_coordinator["email"], :subject => "New publication idea", :from => APP_CONFIG["mailer"]["email"])
  end

  def published(a_publication, office)
    @publication = a_publication
    mail(:to => office["email"], :subject => "Publikation", :from => APP_CONFIG["mailer"]["email"])
  end

  def remind(reminder)
    @reminder = reminder
    mail(:to => reminder.email, :subject => "Reminder from RPubDB", :from => APP_CONFIG["mailer"]["email"])
  end
end
