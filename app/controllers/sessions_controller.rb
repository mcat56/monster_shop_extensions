class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if !user.nil? && user.authenticate(params[:password])
      if user.role == "admin"
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"

        redirect_to "/admin/#{user.id}"
      elsif user.role == "merchant_employee" || user.role == "merchant_admin"
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"

        redirect_to "/merchant/#{user.id}"
      elsif user.role == "default"
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.name}!"

        redirect_to "/profile"
      end
    else
      flash[:error] = 'Credentials were incorrect.'
      redirect_to '/login'
    end
  end

  def logout
    session.delete(:user_id)
    flash[:success] = "You have been logged out"
    redirect_to '/'
  end
end
