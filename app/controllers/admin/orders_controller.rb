class Admin::OrdersController < Admin::BaseController

  def ship
    order = Order.find(params[:order_id])
    order.update_column(:status, 'shipped')

    order.item_orders.each do |item_order|
      new_quantity = item_order.item.inventory - item_order.quantity
      item_order.item.update_attributes(:inventory => new_quantity)
    end

    redirect_to '/admin'
  end
end
