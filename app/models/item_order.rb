class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order
  belongs_to :merchant

  enum status: %w(pending fulfilled cancelled)

  def subtotal
    price * quantity
  end

  def fulfill
    self.update_column(:status, 'fulfilled')

    this_order = Order.find(self.order_id)
    if this_order.item_orders.all?{|item_order| item_order[:status] == 'fulfilled' }
      Order.fulfill(this_order.id)
    end
  end
end
