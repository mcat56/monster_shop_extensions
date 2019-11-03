require 'rails_helper'


describe 'cancel order' do
  describe 'from order show page' do
    before(:each) do
      visit '/'
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
      @bike_shop_emp = @bike_shop.users.create(name: 'Ross', email: 'redross', password: 'emily', role: 2)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50.00, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 25.05, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    end
    it 'can cancel if order status is pending' do
      visit "/items/#{@tire.id}"
      click_button 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_button 'Add To Cart'
      visit "/items/#{@chain.id}"
      click_button 'Add To Cart'
      visit "/cart"
      click_on "Checkout with Existing Address"

      select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')
      click_button "Create Order"

      order = Order.last

      @tire.reload
      @chain.reload
      visit "/profile/orders/#{order.id}"

      expect(page).to have_link('Cancel Order')
      expect(order.status).to eq('pending')
      expect(@tire.inventory).to eq(12)
      expect(@chain.inventory).to eq(5)


      click_link('Cancel Order')

      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('Your order has been cancelled.')

      order.reload
      @tire.reload
      @chain.reload
      expect(order.status).to eq('cancelled')
      expect(@tire.inventory).to eq(12)
      expect(@chain.inventory).to eq(5)

      order = @user.orders.create!(name: 'Meg', street: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

      visit "/profile/orders/#{order.id}"
      expect(page).to have_link('Cancel Order')
    end
    it 'can cancel an order that has been packaged' do
      visit "/items/#{@tire.id}"
      click_button 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_button 'Add To Cart'
      visit "/items/#{@chain.id}"
      click_button 'Add To Cart'
      visit "/cart"

      click_on "Checkout with Existing Address"

      select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')
      click_button "Create Order"

      order = Order.last
      order.update_column(:status, 'packaged')
      order.reload

      click_link 'Log Out'

      click_link 'Login'

      fill_in :email, with: @bike_shop_emp.email
      fill_in :password, with: @bike_shop_emp.password
      click_button 'Log In'

      visit "/merchant/orders/#{order.id}"

      order.item_orders.each do |item_order|
        within "#item-#{item_order.item.id}" do
          click_link 'Fulfill'
        end
      end

     click_link 'Log Out'

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'


      visit "/profile/orders/#{order.id}"

      @tire.reload
      @chain.reload

      expect(page).to have_link('Cancel Order')
      expect(order.status).to eq('packaged')
      expect(@tire.inventory).to eq(10)
      expect(@chain.inventory).to eq(4)


      click_link('Cancel Order')

      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('Your order has been cancelled.')

      order.reload
      @tire.reload
      @chain.reload
      expect(order.status).to eq('cancelled')
      expect(@tire.inventory).to eq(12)
      expect(@chain.inventory).to eq(5)

      order = @user.orders.create!(name: 'Meg', street: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

      visit "/profile/orders/#{order.id}"
      expect(page).to have_link('Cancel Order')
    end
    it 'cannot cancel if status is shipped or already cancelled' do
      order = @user.orders.create!(name: 'Meg', street: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

      visit "/profile/orders/#{order.id}"
      expect(page).to have_link('Cancel Order')

      order_2 = @user.orders.create!(name: 'Meg', street: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "shipped")

      visit "/profile/orders/#{order_2.id}"
      expect(page).to_not have_link('Cancel Order')

      order_3 = @user.orders.create!(name: 'Meg', street: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "cancelled")

      visit "/profile/orders/#{order_3.id}"
      expect(page).to_not have_link('Cancel Order')
    end
  end
end
