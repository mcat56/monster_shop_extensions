class Merchant::ItemOrdersController < Merchant::BaseController

  def fulfill
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.fulfill
    new_quantity = item_order.item.inventory - item_order.quantity
    item_order.item.update_attributes(:inventory => new_quantity)
    flash[:success] = "#{item_order.item.name} has been fulfilled."


    redirect_to "/merchant/orders/#{item_order.order_id}"
  end


end
