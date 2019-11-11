class AddressesFacade

  def initialize(user_id)
    @user = User.find(user_id)
    @address = Address.new 
  end

end
