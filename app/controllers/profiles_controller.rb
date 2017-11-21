class ProfilesController < ApplicationController
  def new
    @employee = Employee.find_by(id: params[:employee_id])
    @profile = @employee.build_profile
  end

  def create
    @employee = Employee.find_by(id: params[:employee_id])
    @profile = @employee.build_profile(profile_params)
    if @profile.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @employee = Employee.find_by(id: params[:employee_id])
    @profile = @employee.profile
  end

  def update
    @employee = Employee.find_by(id: params[:employee_id])
    if @employee.profile.update(profile_params)
      redirect_to root_path, notice: "Profile is successfully updated"
    else
      render :edit
    end
  end

  def destroy
  end


  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :email, :designation, :date_of_birth, :date_of_joining, :image, :image_cache)
  end
end
