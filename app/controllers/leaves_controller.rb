class LeavesController < ApplicationController
  def index
  end

  def new
    @leaves_history = LeavesHistory.new
  end

  def create
  	@employee = Employee.find_by(id: params[:employee_id])
  	@leaves_history = @employee.build_leaves_history(leaves_history_params)
  	@total_days = @leaves_history.end_date - @leaves_history.start_date).to_i
    @leaves_history.employee_id = current_employee.id
    @leaves_history.status = 2
    @leaves_history.leaves_taken = @total_days.size
    if current_employee.leaves_balance - @total_days > 0  #employee can take leave
    	current_employee.decrement(:leaves_balance, @total_days)
      @leaves_history.save
      redirect_to leaves_path
    else
      render 'new'
    end
	end

	 private

  def leaves_history_params
    params.require(:leaves_history).permit(:start_date, :end_date, :status)
  end
end
