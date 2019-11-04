class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :item_orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates :zip, format: { with: /\d{5}/ }

  def enabled?
    self.status == 'enabled'
  end

  def enable
    self.update_column(:status, 'enabled')
  end

  def disable
    self.update_column(:status, 'disabled')
  end

  def no_orders?
    item_orders.joins(order: :user).where("users.is_active = true").empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(order: :address).joins(order: :user).where("users.is_active = true").pluck("addresses.city")
  end

end
