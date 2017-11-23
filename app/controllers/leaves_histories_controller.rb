class LeavesHistoriesController < ApplicationController
  def index
    @employee = Employee.find_by(id: params[:employee_id])
    @leaves_histories = @employee.leaves_histories.all
  end

  def new
    @employee = Employee.find_by(id: params[:employee_id])
    @leaves_history = @employee.leaves_histories.build
  end

  def create
  	@employee = Employee.find_by(id: params[:employee_id])
    @leaves_history = @employee.leaves_histories.build(leaves_history_params)
  	@total_days = (@leaves_history.end_date.to_date - @leaves_history.start_date.to_date).to_i
    if (@employee.leaves_balance - @total_days).to_i >= 0 #employee can take leave
      @leaves_history.leaves_taken = @total_days
      if @total_days != 0
        @leaves_history.update_attributes(:status => 2, :leaves_taken => @total_days)
      else
         @leaves_history.update_attributes(:status => 2, :leaves_taken => 1)
      end 
      decrease_leave_balance(@employee,@leaves_history) if @leaves_history.status == "approved"
      @leaves_history.save
      redirect_to employee_leaves_histories_path, notice: "Request sent to admin for approval"
    else
      redirect_to employee_leaves_histories_path, notice: "You dont have enough leaves"
    end
	end

  def cancel_leave
    @employee = Employee.find_by(id: params[:employee_id])
    @leaves_history = @employee.leaves_histories.find_by(id: params[:id])
    @leaves_history.update_attribute(status: 4)
    redirect_to employee_leaves_histories_path, notice: "You cancelled the request"
  end

  def destroy
    @employee = Employee.find_by(id: params[:employee_id])
    @leaves_history = @employee.leaves_histories.find_by(id: params[:id])
    #@leaves_history = @employee.leaves_histories
    if @leaves_history.status == "pending"
      @leaves_history.destroy
      #@employee.leaves_history.destroy(params[:id])
      redirect_to employee_leaves_histories_path, notice: "You cancelled the request"
    else
      render 'index' ,notice: "You can not cancel the request"
    end
  end


  def show_leaves
    @employee = Employee.find_by(id: params[:employee_id])
    redirect_to show_leaves_admin_employee_path(id: params[:employee_id])

  end

  def approve_leave
    @employee = Employee.find_by(id: params[:employee_id])
    @employee_leaves_data = @employee.leaves_histories.find_by(id: params[:id])
    @profile = Profile.find_by(employee_id: params[:employee_id])
    @total_leaves_taken = 0
    #@employee_leaves_data.each do |employee_leaves_row|
      #@total_leaves_taken = @total_leaves_taken + employee_leaves_row.leaves_taken
    #end
    byebug
    remaining_leaves_balance = @employee.leaves_balance - @employee_leaves_data.leaves_taken
    @employee.update_attributes(leaves_balance: remaining_leaves_balance)
    @employee_leaves_data.update_attributes(status: 0)
    AdminMailer.send_leave_response(@employee,@employee_leaves_data.status,@profile.first_name).deliver
    redirect_to show_leaves_admin_employee_path(params[:employee_id])
    # mail sent to employee for approval
  end

  def disapprove_leave
    @employee = Employee.find_by(id: params[:employee_id])
    @employee_leaves_data = @employee.leaves_histories.find_by(id: params[:id])
    @profile = Profile.find_by(employee_id: params[:employee_id])
    @employee_leaves_data.update_attributes(status: 1)
    # mail sent to employee for disapproval
    AdminMailer.send_leave_response(@employee,@employee_leaves_data.status,@profile.first_name).deliver
    redirect_to show_leaves_admin_employee_path(params[:employee_id])
  end

	 private

  def leaves_history_params
    params.require(:leaves_history).permit(:start_date, :end_date)
  end

  def decrease_leave_balance employee,leaves_history
    employee.update_attributes(:leaves_balance => @employee.leaves_balance - leaves_history.leaves_taken)
  end
end
