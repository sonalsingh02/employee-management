class AdminMailer < ApplicationMailer
	include ApplicationHelper
  default :from => "\"Admin\" <no-reply@employeeportal.com>"

  def send_leave_response(employee,message,name)
  	@employee = employee
    @message = message
    @name = name
    mail(:subject => "LEAVES RESPONSE", :to => @employee.email, :reply_to => @employee.email)
  end
end
