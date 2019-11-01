require 'rails_helper'


describe 'cancel order' do
  describe 'from order show page' do
    before(:each) do
      visit '/'
      @user = User.create(name: 'Patti', address: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701', email: 'pattimonkey34@gmail.com', password: 'banana')

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
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
      click_on "Checkout"

      fill_in :name, with: 'Bert'
      fill_in :address, with: '123 Sesame St.'
      fill_in :city, with: 'NYC'
      fill_in :state, with: 'New York'
      fill_in :zip, with: 10001

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

      order = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

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
      click_on "Checkout"

      fill_in :name, with: 'Bert'
      fill_in :address, with: '123 Sesame St.'
      fill_in :city, with: 'NYC'
      fill_in :state, with: 'New York'
      fill_in :zip, with: 10001

      click_button "Create Order"

      order = Order.last
      order.update_column(:status, 'packaged')
      order.reload

      @tire.reload
      @chain.reload
      visit "/profile/orders/#{order.id}"

      expect(page).to have_link('Cancel Order')
      expect(order.status).to eq('packaged')
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

      order = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

      visit "/profile/orders/#{order.id}"
      expect(page).to have_link('Cancel Order')
    end
    it 'cannot cancel if status is shipped or already cancelled' do
      order = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "packaged")

      visit "/profile/orders/#{order.id}"
      expect(page).to have_link('Cancel Order')

      order_2 = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "shipped")

      visit "/profile/orders/#{order_2.id}"
      expect(page).to_not have_link('Cancel Order')

      order_3 = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218, status: "cancelled")

      visit "/profile/orders/#{order_3.id}"
      expect(page).to_not have_link('Cancel Order')
    end
  end
end
