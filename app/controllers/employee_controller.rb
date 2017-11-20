class EmployeeController < ApplicationController
	before_action :authenticate_user!
end
