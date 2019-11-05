class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user,
                :current_admin?, :current_merchant?,
                :merchant_status_button_text,
                :merchant_status_button_action

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant?
    current_user && (current_user.merchant_employee? || current_user.merchant_admin?)
  end

  def merchant_status_button_text(merchant)
    if merchant.enabled? == true
      @button_text = 'Disable'
    else
      @button_text = 'Enable'
    end
    @button_text
  end

end
