class Api::V1::ProfilesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create_profile, :show_profile]

  def create_profile
    @errors = []
    #check_key
    validate_profile_params(params) if @errors.empty?
    if @errors.empty?
      params[:first_name] = params[:first_name].to_s.strip
      params[:last_name] = params[:last_name].to_s.strip
      params[:email] = params[:email].to_s.strip
      params[:designation] = params[:designation].to_s.strip
      params[:date_of_birth] = params[:date_of_birth].to_s.strip
      params[:date_of_joining] = params[:date_of_joining].to_s.strip
      params[:image] = params[:image].to_s.strip
      @profile = Profile.new(params)
      if @profile.save
        render json: { status: "Success", message: "Profile created successfully", code: 200 }
      else
        render json: { status: "Failure", message: @profile.errors.full_messages, code: 500 }
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

  def show_profile
    @errors = []
    validate_profile_params_show(params) if @errors.empty?
    if @errors.empty?
      validated_params = []
      @profile = []
      params[:customer_id] = params[:customer_id].to_s.strip
      @profile = Profile.find_by(customer_id: params[:customer_id])
      if !@profile.nil?
        if !@profile.empty?
          render json: { status: "Success", message: @profile, code: 200 }
        else
          render json: { status: "Failure", message: "No Records Found", code: 500 }
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

  
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :email, :designation, :date_of_birth, :date_of_joining, :image)
  end

  def all_letters_or_digits(str)
    str[/\A[a-zA-Z0-9\s]+\Z/i]  == str
  end

  def validate_email(str)
    str[/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i]  == str
  end

  def validate_date(str)
    str[/\A[12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])/i]  == str
  end

  def validate_image(str)
    str[/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i]  == str
  end
  
  def all_letters(str)
    str[/\A[a-zA-Z\s]+\Z/i]  == str
  end

  def all_digits(str)
    str[/\A[0-9\s]+\Z/i]  == str
  end

  def validate_profile_params params
    unless params[:first_name].to_s.strip.empty?
      if !all_letters(params[:name].to_s.strip)
        @errors << "First Name is invalid"
      end
    else
       @errors << "First Name is empty"
    end
    unless params[:designation].to_s.strip.empty?
      if !all_letters(params[:designation].to_s.strip)
        @errors << "Designation is invalid"
      end
    else
       @errors << "Designation is empty"
    end
    unless params[:last_name].to_s.strip.empty?
      if !all_letters(params[:last_name].to_s.strip)
        @errors << "Last Name is invalid"
      end
    else
       @errors << "Last Name is empty"
    end
    unless params[:email].to_s.strip.empty?
      if !validate_email(params[:email].to_s.strip)
        @errors << "Email is invalid"
      end
    else
       @errors << "Email is empty"
    end
   unless params[:date_of_birth].to_s.strip.empty?
      if !validate_date(params[:date_of_birth].to_s.strip)
        @errors << "Date Of Birth is invalid"
      end
    else
       @errors << "Date Of Birth is empty"
    end
    unless params[:date_of_joining].to_s.strip.empty?
      if !validate_date(params[:date_of_joining].to_s.strip)
        @errors << "Date Of Joining is invalid"
      end
    else
       @errors << "Date Of Joining is empty"
    end
    unless params[:image].to_s.strip.empty?
      if !validate_image(params[:image].to_s.strip)
        @errors << "Image Url is invalid"
      end
    else
       @errors << "Image Url is empty"
    end
  end


  def validate_profile_params_show params
    unless params[:id].to_s.strip.empty?
      if !all_digits(params[:id].to_s.strip)
        @errors << "Id is invalid"
      end
    else
       @errors << "id is empty"
    end
  end

  def check_key
    if(params.has_key?(:first_name) && params.has_key?(:last_name) && params.has_key?(:email) && params.has_key?(:mobile_number) && !params.has_key?(:message))
      @errors << "Message id key is missing"
    elsif(params.has_key?(:name) && params.has_key?(:email) && !params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Mobile Number key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Email key is missing"
    elsif(!params.has_key?(:name) && params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Name key is missing"
    elsif(params.has_key?(:name) && params.has_key?(:email) && !params.has_key?(:mobile_number) && !params.has_key?(:message))
      @errors << "Mobile Number and Message key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && !params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Email and Mobile Number key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && !params.has_key?(:message))
        @errors << "Message and email key is missing"
    elsif(!params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Name and email key is missing"
    end
  end
end