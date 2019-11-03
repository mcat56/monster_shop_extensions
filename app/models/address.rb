class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  validates_presence_of :street, :city, :state, :zip
  validates_presence_of :nickname, uniqueness: true

  def get_full_address
    self.nickname.capitalize + ': ' + self.street + ' ' + self.city + ' ' + self.state + ' ' + self.zip
  end

end
