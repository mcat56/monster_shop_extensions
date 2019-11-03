class Address < ApplicationRecord
  belongs_to :user
  validates_presence_of :address, :city, :state, :zip
  validates_presence_of :nickname, uniqueness: true

  def get_full_address
    self.nickname.capitalize + ': ' + self.address + ' ' + self.city + ' ' + self.state + ' ' + self.zip
  end

end
