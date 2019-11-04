class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:user_id])

    if request.env['PATH_INFO'] == "/admin/users/#{@user.id}/edit/password"
      @password_change = true
    else
      @password_change = false
    end
  end

  def show
    @user = User.find(params[:user_id])
  end

  def update
    @user = User.find(params[:user_id])
    @user.update(user_params)

    if @user.save
      flash[:sucess] = "You have successfully updated #{@user.name}'s profile!" if request.env['REQUEST_METHOD'] == "PUT"
      flash[:sucess] = "You have successfully updated #{@user.name}'s password!" if request.env['REQUEST_METHOD'] == "PATCH"
      redirect_to "/admin/users"
    else
      flash[:error] = @user.errors.full_messages.to_sentence

      redirect_to "/admin/users/#{@user.id}/edit" if request.env['REQUEST_METHOD'] == "PUT"
      redirect_to "/admin/users/#{@user.id}/edit/password" if request.env['REQUEST_METHOD'] == "PATCH"
    end
  end

  def edit_role
    @user = User.find(params[:user_id])
    @merchants = Merchant.all
  end

  def upgrade
    @user = User.find(params[:user_id])
    original_role = @user.role

    if user_params[:merchant] == '' || user_params[:role] == ''
      flash[:error] = "You must select a valid Merchant and Role"
      redirect_to "/admin/users/#{@user.id}/edit_role"
    elsif user_params[:role] != original_role
      @user.role_upgrade(user_params[:merchant], user_params[:role])
      flash[:sucess] = "You have successfully changed #{@user.name}'s role to #{@user.role}."
      redirect_to '/admin/users'
    end
  end

  def change_active_status
    user = User.find(params[:user_id])
    user.toggle_active_status
    if user.is_active == false
      flash[:success] = "#{user.name}'s account has been disabled."
    else
      flash[:success] = "#{user.name}'s account has been enabled."
    end
    redirect_to '/admin/users'
  end

  private

  def user_params
    params.permit(:name, :city, :street, :city, :state, :zip, :email, :password, :password_confirmation, :merchant, :role)
  end
end
