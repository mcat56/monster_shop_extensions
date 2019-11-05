class UsersController < ApplicationController


  def new
  end

  def show
    if current_user
      @user = User.find(params[:user_id])
    else
      render file: "/public/404"
    end
  end

  def create
    @address = Address.create( {
      street: user_params[:street],
      city: user_params[:city],
      state: user_params[:state],
      zip: user_params[:zip],
      })
    @new_user = User.new( {
      name: user_params[:name],
      email: user_params[:email],
      password: user_params[:password],
      password_confirmation: user_params[:password_confirmation]
      })
    if @new_user.save
      @new_user.addresses << @address
      session[:user_id] = @new_user.id
      redirect_to "/profile/#{@new_user.id}"
      flash[:sucess] = "You have registered successfully! You are now logged in as #{@new_user.name}."
    else
      flash[:error] = @new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])

    if request.env['PATH_INFO'] == "/profile/#{@user.id}/edit/password"
      @password_change = true
    else
      @password_change = false
    end
  end

  def update
    @user = User.find(params[:user_id])
    @user.update(user_params)

    if @user.save
      flash[:sucess] = "Hello, #{@user.name}! You have successfully updated your profile." if request.env['REQUEST_METHOD'] == "PUT"
      flash[:sucess] = "Hello, #{@user.name}! You have successfully updated your password." if request.env['REQUEST_METHOD'] == "PATCH"
      redirect_to "/profile/#{@user.id}"
    else
      flash[:error] = @user.errors.full_messages.to_sentence

      redirect_to "/profile/#{@user.id}/edit" if request.env['REQUEST_METHOD'] == "PUT"
      redirect_to "/profile/#{@user.id}/edit/password" if request.env['REQUEST_METHOD'] == "PATCH"
    end
  end

  private

  def user_params
    params.permit(:name, :city, :street, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end
