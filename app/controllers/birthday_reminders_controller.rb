class BirthdayRemindersController < ApplicationController
	def self.send_birthday_email_reminders 
  	@employees = Employee.all
  	#@employee = Employee.find_by(id: params[:employee_id])
  	@profile = []
  	@employees.each do |employee|
    	@profile.push(employee.profile)
    end
		email_addresses = []
			@profile.each do |pro|
				puts pro.inspect
			end
		@profile.each_with_index do |pro, i|
    	email_addresses[i] = pro.email.to_s
    end
    p "email_addresses to send to:"
    #p email_addresses.to_s
		@profile.each do |pro|
    	p "this user is"
      p pro.first_name
      if pro.date_of_birth.try(:strftime, "%m") == Date.today.strftime("%m") && pro.date_of_birth.try(:strftime, "%d") == Date.today.strftime("%d")
      	p "reminder sent"
        EmailMailer.send_birthday_reminders(pro.first_name, pro.email.to_s).deliver
      end
    end
  end
end
