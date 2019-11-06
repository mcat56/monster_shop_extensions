class SessionsController < ApplicationController

  def new
    if current_admin?
      flash[:notice] = 'You are already logged in.'
      redirect_to "/admin"
    elsif current_merchant?
      flash[:notice] = 'You are already logged in.'
      redirect_to "/merchant"
    elsif current_user
      flash[:notice] = 'You are already logged in.'
      redirect_to "/profile/#{current_user.id}"
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.nil?
      flash[:error] = 'Please register'
      redirect_to '/login'
    else
      if user.is_active == false
        flash[:error] = 'Unable to login. Your account has been deactivated.'
        redirect_to '/login'
      else
        if !user.nil? && user.authenticate(params[:password])
          session[:user_id] = user.id
          flash[:success] = "Welcome, #{user.name}! You are logged in."
          if user.role == "default"
            redirect_to "/profile/#{user.id}"
          elsif user.role == "merchant_employee" || user.role == "merchant_admin"
            redirect_to "/merchant"
          elsif user.role == "admin"
            redirect_to "/admin"
          end
        else
          flash[:error] = 'Credentials were incorrect.'
          redirect_to '/login'
        end
      end
    end
  end


  def destroy
    session.delete :user_id
    session.delete :cart
    session.delete :coupon
    @current_user = nil
    flash[:success] = "You have been logged out."

    redirect_to '/'
  end
end
