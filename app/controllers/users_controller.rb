class UsersController < ApplicationController

  def new
  end

  def show
    render file: "/public/404" unless current_user
  end

  def create
    new_user = User.create!(user_params)
    session[:user_id] = new_user.id

    flash[:sucess] = "You have registered successfully! You are now logged in as #{new_user.name}."
    redirect_to '/profile'
  end

  private

  def user_params
    params.permit(:name, :city, :address, :city, :state, :zip, :email, :password)
  end

end
