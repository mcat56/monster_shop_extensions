class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :coupon, optional: true 

  validates_presence_of :name, :status

  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def item_count
    items.length
  end

  def self.fulfill(order_id)
    Order.where(id: order_id).update(status: 1)
  end

  def merchant_item_quantity(merchant)
    item_orders.where(merchant_id: merchant.id).sum(:quantity)
  end

  def merchant_total_value(merchant)
     item_orders.where(merchant_id: merchant.id).sum('item_orders.price * item_orders.quantity')
  end
end
