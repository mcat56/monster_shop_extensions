class Admin::OrdersController < Admin::BaseController

  def ship
    order = Order.find(params[:order_id])
    order.update_column(:status, 'shipped')

    redirect_to '/admin'
  end
end
