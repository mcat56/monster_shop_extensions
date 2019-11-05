class CartController < ApplicationController
  before_action :not_admin

  def not_admin
    render file: "/public/404" if current_admin?
  end

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
    if params[:coupon]
      @coupon = Coupon.where(name: params[:apply_coupon]).pluck(:id).first
    end

  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increment_decrement
    item = Item.find(params[:item_id])
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
      if cart.limit_reached?(params[:item_id])
        flash[:notice] = "You have reached the inventory limit for #{item.name}!"
      end
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      if cart.quantity_zero?(params[:item_id])
        flash[:notice] = "#{item.name} has been removed from your cart."
      end
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end
end
