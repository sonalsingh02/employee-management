class EmailMailer < ApplicationMailer
	include ApplicationHelper
  default :from => "\"EmployeePortal\" <no-reply@employeeportal.com>"

  def send_birthday_reminders(birthday_person, email_address)
    p "we in send_birthday_reminders mailer"
    p email_address
    @birthday_person = birthday_person
    mail(:subject => "MANY MANY HAPPY RETURNS OF THE DAY", :to => email_address, :reply_to => email_address)
  end

  def send_joining_reminders(work_anniversary_person, email_address)
  	p "we in send_birthday_reminders mailer"
    p email_address
    @work_anniversary_person = work_anniversary_person
    mail(:subject => "Congratulations!!!!!!!!!!!!", :to => email_address, :reply_to => email_address)
  end
end
