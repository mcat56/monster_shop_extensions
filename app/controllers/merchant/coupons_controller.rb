class Merchant::CouponsController < Merchant::BaseController

  def index
    merchant = Merchant.find(current_user.merchant_id)
    @coupons = merchant.coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = @merchant.coupons.new
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

  def edit
    @coupon = Coupon.find(params[:id])
    @merchant = @coupon.merchant
  end

  def update
    coupon = Coupon.find(params[:format])
    coupon.update(coupon_params)

    if coupon.save
      flash[:success] = 'Your coupon has been updated'
      redirect_to '/merchant/coupons'
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      redirect_to "/merchant/coupons/#{coupon.id}/edit"
    end
  end

  def destroy
    Coupon.destroy(params[:id])

    flash[:success] = 'Coupon Deleted'
    redirect_to '/merchant/coupons'
  end


  private

  def coupon_params
    params.require(:coupon).permit(Coupon.column_names)
  end


end
