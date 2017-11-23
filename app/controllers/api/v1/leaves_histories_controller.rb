#apply and can see applied leaves

class Api::V1::LeavesHistoriesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create_leave, :show_leaves]

  def create_leave
    @errors = []
    check_key
    validate_leaves_history_params(leaves_history_params) if @errors.empty?
    if @errors.empty?
      validated_params = [] 
      validated_params = leaves_history_params
      #Rails.logger.info("****#{upload_params[:name].strip}*********")
      validated_params[:employee_id] = validated_params[:employee_id].to_s.strip
      validated_params[:start_date] = validated_params[:start_date].to_s.strip
      validated_params[:end_date] = validated_params[:end_date].to_s.strip
      @employee = Employee.find_by(id: validated_params[:employee_id])
    	@leaves_history = @employee.leaves_histories.build(validated_params)
  		@total_days = (@leaves_history.end_date.to_date - @leaves_history.start_date.to_date).to_i
    	if (@employee.leaves_balance - @total_days).to_i >= 0 #employee can take leave
     		@leaves_history.leaves_taken = @total_days
	      if @total_days != 0
	        @leaves_history.update_attributes(:status => 2, :leaves_taken => @total_days)
	      else
	         @leaves_history.update_attributes(:status => 2, :leaves_taken => 1)
	      end 
	      decrease_leave_balance(@employee,@leaves_history) if @leaves_history.status == "approved"
	      if @leaves_history.save
	     		render json: { status: "Success", message: "Leaves applied successfully", code: 200 }
	     	else
        	render json: { status: "Failure", message: @leaves_history.errors.full_messages, code: 500 }
      	end
    	else
    		render json: { status: "Failure", message: "You dont have enough leaves", code: 500 }
    	end
    else
      if @errors.length == 1
        render json: { status: "Failure", message: @errors, code: 500 }
      else
        message = ""
        @errors.each do |e|
          message += e + ";"
        end
        render json: { :status => "Failure", :message => message, :code => 500 }
      end
    end
  end

  def show_leaves
    #byebug
    @errors = []
    validate_leaves_history_params_show(params) if @errors.empty?
    
    if @errors.empty?
      validated_params = []
      @employee = []
      params[:employee_id] = params[:employee_id].to_s.strip
      @employee = Employee.find_by(id: params[:employee_id])
      if !@employee.nil?
        @leaves_histories = @employee.leaves_histories.all
        if !@leaves_histories.empty?
          render json: { status: "Success", message: @leaves_histories, code: 200 }
        else
          render json: { status: "Failure", message: "No Leaves Found", code: 500 }
        end
      else
        render json: { status: "Failure", message: "Wrong Employee Id", code: 200 }
      end
    else
      if @errors.length == 1
        render json: { status: "Failure", message: @errors, code: 500 }
      else
        message = ""
        @errors.each do |e|
          message += e + ";"
        end
        render json: { :status => "Failure", :message => message, :code => 500 }
      end
    end
  end


  private

 	def leaves_history_params
    params.require(:leaves_history).permit(:employee_id,:start_date, :end_date)
  end

  def validate_date(str)
    str[/\A[12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])/i]  == str
  end

  def all_digits(str)
    str[/\A[0-9\s]+\Z/i]  == str
  end

  def validate_leaves_history_params params
  	unless params[:employee_id].to_s.strip.empty?
      if !all_digits(params[:employee_id].to_s.strip)
        @errors << "Employee Id is invalid"
      end
    else
       @errors << "Employee Id is empty"
    end
 		unless params[:start_date].to_s.strip.empty?
      if !validate_date(params[:start_date].to_s.strip)
        @errors << "Start Date is invalid"
      end
    else
       @errors << "Start Date is empty"
    end
    unless params[:end_date].to_s.strip.empty?
      if !validate_date(params[:end_date].to_s.strip)
        @errors << "End Date is invalid"
      end
    else
       @errors << "Date Of Joining is empty"
    end
  end


  def validate_leaves_history_params_show params
    unless params[:employee_id].to_s.strip.empty?
      if !all_digits(params[:employee_id].to_s.strip)
        @errors << "Id is invalid"
      end
    else
       @errors << "id is empty"
    end
  end

  def check_key
    if(!params.has_key?(:employee_id))
        @errors << "Id key is missing"
    end
  end

  def decrease_leave_balance employee,leaves_history
    employee.update_attributes(:leaves_balance => @employee.leaves_balance - leaves_history.leaves_taken)
  end
end