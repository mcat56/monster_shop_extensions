class OrdersController <ApplicationController

  def index
    @orders = Order.where(user_id: session[:user_id]).joins(:user).where("users.is_active = true")
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def update
    order = Order.find(params[:id])
    order.update(order_hash)

    flash[:success] = 'Order information updated'
    redirect_to '/profile/orders'
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    user = User.find(session[:user_id])
    if user.orders.any? {|order| order.coupon_id == order_hash[:coupon_id] }
      order = user.orders.create(order_hash)
      order.coupon_id = nil
    else
      order = user.orders.create(order_hash)
    end
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.adjusted_price(order.coupon_id),
          merchant: item.merchant
          })
      end
      session.delete(:cart)
      if order.item_orders.any? {|item_order| item_order.item.price != item_order.item.adjusted_price(order.coupon_id)}
        message = 'Coupon has been applied'
      else
        message = ''
        order.coupon_id = nil
      end
      flash[:success] = 'Your order has been placed!' + " " + message
      redirect_to "/profile/orders/#{order.id}"
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    status = order.status
    order.update_attributes(:status => 'cancelled')

    order.item_orders.each do |item_order|
      item_order.update_attributes(:status => 2)

      if status == 'packaged'
        item = Item.find(item_order.item_id)
        new_quantity = item.inventory + item_order.quantity
        item.update_attributes(:inventory => new_quantity)
      end
    end

    flash[:success] = 'Your order has been cancelled.'
    redirect_to "/profile/#{session[:user_id]}"
  end


  private

  def order_hash
    order_hash = {}
    address = Address.find(order_params[:address])
    order_hash = {
      name: order_params[:name],
      address: address,
      coupon_id: Coupon.where(name: params[:coupon]).pluck(:id).first
    }
  end

  def order_params
    params.permit(:name, :address, :coupon)
  end
end
