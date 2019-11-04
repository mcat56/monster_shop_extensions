class Merchant::CouponsController < Merchant::BaseController

  def index
    merchant = Merchant.find(current_user.merchant_id)
    @coupons = merchant.coupons
  end

  def new
    @coupon = Coupon.new
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def create
    merchant = Merchant.find(params[:format])
    coupon =  merchant.coupons.new(coupon_params)

    if coupon.save
      flash[:success] = 'Your coupon has been created'
      redirect_to '/merchant/coupons'
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      redirect_to '/merchant/coupons/new'
    end
  end



  private

  def coupon_params
    params.require(:coupon).permit(Coupon.column_names)
  end


end
