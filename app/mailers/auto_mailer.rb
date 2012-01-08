class AutoMailer < ActionMailer::Base

  # sends the info of a new idea to all coordinators
  def new_idea(a_publication, a_coordinator)
    @publication = a_publication
    mail(:to => a_coordinator["email"], :subject => "New publication idea", :from => APP_CONFIG["mailer"]["email"])
  end

  def published(a_publication, office)
    @publication = publication
    mail(:to => a_coordinator["email"], :subject => "Neue Publikation", :from => APP_CONFIG["mailer"]["email"])
  end
end
