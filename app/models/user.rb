class User < ApplicationRecord
  has_many :addresses
  has_many :orders
  belongs_to :merchant, optional: true


  validates_presence_of :name 
  validates :email, uniqueness: true, presence: true

  validates :password, :presence => true, allow_nil: false

  has_secure_password

  enum role: %w(default merchant_employee merchant_admin admin)

  def role_upgrade(merchant_id, new_role)
    self.update_column(:role, new_role)
    self.update_column(:merchant_id, merchant_id)
  end

  def toggle_active_status
    if is_active
      update_column(:is_active, false)
    else
      update_column(:is_active, true)
    end
  end


end
