require 'rails_helper'

describe 'user can apply coupon to order that has those merchant items' do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @coupon_1 = @meg.coupons.create(name: 'SUMMER18', percent: 0.25, enabled?: false)
    @coupon_2 = @meg.coupons.create(name: 'SUMMER18', percent: 0.25, enabled?: true)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @user_2 = User.create(name: 'Marcel', email: 'monkey34@gmail.com', password: 'bananas')
    address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
    address_2 = @user_2.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

    @order_1 = @user.orders.create!(name: 'Meg', address: address_1, coupon: @coupon_1)
    @order_2 = @user_2.orders.create!(name: 'Brian', address: address_2, coupon: @coupon_2)
    @order_3 = @user_2.orders.create!(name: 'Mike', address: address_2, coupon: @coupon_2)

    @order_1.item_orders.create!(item: @paper, price: @paper.price, quantity: 2, merchant: @mike)
    @order_1.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 1, merchant: @mike)
    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 1, merchant: @meg)

    @order_2.item_orders.create!(item: @paper, price: @paper.price, quantity: 2, merchant: @mike)
    @order_2.item_orders.create!(item: @pencil, price: @pencil.price, quantity: 1, merchant: @mike)
    @order_2.item_orders.create!(item: @tire, price: @tire.price, quantity: 1, merchant: @meg)

    visit '/'
    click_link 'Login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

  end
  it 'applies coupon if merchant item is in order coupon is enabled and not used yet and shows which coupon was used' do
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit '/'

    visit "/cart"
    click_on "Checkout with Existing Address"

    select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')
    fill_in 'Coupon', with: 'SUMMER18'

    click_button "Create Order"
    new_order = Order.last

    expect(page).to have_link('Cart: 0')
    expect(page).to have_content('Your order has been placed!')
    expect(page).to have_content('Coupon has been applied')
    expect(page).to have_content('Coupon Applied: SUMMER18')
    expect(current_path).to eq("/profile/orders/#{new_order.id}")
    expect(page).to have_content('Total: $117.00')
  end
  it 'will not apply if coupon is disabled' do
    expect(@order_1.grandtotal).to eq(142.0)
    expect(@order_1.coupon_id).to eq(nil)
  end
  it 'will not apply if user already used coupon' do
    click_link 'Log Out'

    click_link 'Login'

    fill_in :email, with: @user_2.email
    fill_in :password, with: @user_2.password
    click_button 'Log In'

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit '/cart'
    click_on "Checkout with Existing Address"

    select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')
    fill_in 'Coupon', with: 'SUMMER18'

    click_button "Create Order"

    new_order = Order.last

    expect(page).to have_link('Cart: 0')
    expect(new_order.coupon_id).to eq(nil)
    expect(page).to have_content('Your order has been placed!')
    expect(page).to_not have_content('Coupon has been applied')
    expect(current_path).to eq("/profile/orders/#{new_order.id}")
    expect(page).to have_content('Total: $142.00')
  end
  it 'user can continue shopping and coupon will be remembered' do
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit '/cart'

    fill_in :apply_coupon, with: 'SUMMER18'
    click_button 'Apply'

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"

    visit '/cart'

    expect(page).to have_content('Discounted Total: $117.00')
    expect(find_field('Apply coupon').value).to eq 'SUMMER18'
  end
end
