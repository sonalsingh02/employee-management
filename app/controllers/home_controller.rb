class HomeController < ApplicationController
	def index
		if !current_employee.profile.nil?
			@date_of_birth = current_employee.profile.date_of_birth if !current_employee.profile.date_of_birth.nil?
			@date_of_joining = current_employee.profile.date_of_joining.strftime("%B %d, %Y") if !current_employee.profile.date_of_joining.nil?
	  	@date_of_birth = @date_of_birth.strftime("%B %d, %Y") if @date_of_birth
	    @leaves_histories = current_employee.leaves_histories.last if !current_employee.leaves_histories.nil?
	    if !@leaves_histories.nil?
		    @leaves_start_date = @leaves_histories.start_date.strftime("%B %d, %Y") if !@leaves_histories.start_date.nil?
		    @leaves_end_date = @leaves_histories.end_date.strftime("%B %d, %Y") if !@leaves_histories.end_date.nil?
		    @leaves_status = @leaves_histories.status if !@leaves_histories.status.nil?
		 	end
		end
	end
end
