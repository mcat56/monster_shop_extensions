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
    binding.pry
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    user = User.find(session[:user_id])
#
    if order_params.has_key?('zip')
      order = user.orders.create(order_params)
    else
      @address = Address.find(order_params[:address])
      order_hash = create_order_hash
      order = user.orders.create(order_hash)
    end
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price,
          merchant: item.merchant
          })
      end
      session.delete(:cart)
      flash[:success] = 'Your order has been placed!'
      redirect_to "/profile/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    status = order.status
    order.update_attributes(:status => 'cancelled')

    order.item_orders.each do |item_order|
      item_order.update_attributes(:status => 0)

      if status == 'packaged'
        item = Item.find(item_order.item_id)
        new_quantity = item.inventory + item_order.quantity
        item.update_attributes(:inventory => new_quantity)
      end
    end

    flash[:success] = 'Your order has been cancelled.'
    redirect_to "/profile/#{session[:user_id]}"
  end

  def update

  end

  private

  def create_order_hash
    order_hash = {}
    order_hash[:name] = order_params[:name]
    order_hash[:street] = @address.street
    order_hash[:city] = @address.city
    order_hash[:state] = @address.state
    order_hash[:zip] = @address.zip
    order_hash[:address_id] = @address.id
    order_hash
  end

  def order_params
    params.permit(:name, :nickname, :street, :city, :state, :zip, :address)
  end
end
