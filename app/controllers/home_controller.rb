class HomeController < ApplicationController

	def index
  	@date_of_birth = current_employee.profile.date_of_birth
  	@date_of_joining = current_employee.profile.date_of_joining.strftime("%B %d, %Y")
  	@date_of_birth = @date_of_birth.strftime("%B %d, %Y")
    @leaves_histories = current_employee.leaves_histories.last
    if !@leaves_histories.nil?
	    @leaves_start_date = @leaves_histories.start_date.strftime("%B %d, %Y")
	    @leaves_end_date = @leaves_histories.end_date.strftime("%B %d, %Y")
	    @leaves_status = @leaves_histories.status
	 	end
	end
end
