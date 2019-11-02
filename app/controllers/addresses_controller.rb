class AddressesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    user = User.find(params[:user_id])
    @address = user.addresses.new(address_params)
    if @address.save
      flash[:success] = 'Your address has been added.'
      redirect_to "/profile/#{user.id}"
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      redirect_to "/users/#{user.id}/addresses/new"
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  private

  def address_params
    params.require(:address).permit(Address.column_names)
  end

end
