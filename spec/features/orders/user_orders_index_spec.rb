require 'rails_helper'

describe 'As a registered user I am sent to my orders page after creating an order ' do
  it 'displays all of my orders' do
    visit '/'
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

    click_link 'Login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50.00, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 25.05, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 50.00, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 4)


    order_1 = @user.orders.create!(name: 'Richy Rich', address: @address_1) 
    order_2 = @user.orders.create!(name: 'Alice Wonder', address: @address_1)
    order_3 = @user.orders.create!(name: 'Sonny Moore', address: @address_1)

    tire.item_orders.create(quantity: 2, price: 100.00, order_id: order_1.id, merchant: bike_shop)
    chain.item_orders.create(quantity: 1, price: 25.05, order_id: order_1.id, merchant: bike_shop)
    shifter.item_orders.create(quantity: 3, price: 150.00, order_id: order_2.id, merchant: bike_shop)

    tire.item_orders.create(quantity: 2, price: 100.00, order_id: order_2.id, merchant: bike_shop)
    chain.item_orders.create(quantity: 1, price: 25.05, order_id: order_2.id, merchant: bike_shop)
    shifter.item_orders.create(quantity: 3, price: 150.00, order_id: order_3.id, merchant: bike_shop)


    visit "/profile/orders"


    within "#orders-#{order_1.id}" do
      expect(page).to have_content("Order ID: #{order_1.id}")
      expect(page).to have_content("Creation Date: #{order_1.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content("Last Updated: #{order_1.updated_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content('Status: pending')
      expect(page).to have_content('Number of Items: 2')
      expect(page).to have_content('Grand Total: $225.05')

      click_link "#{order_1.id}"

      expect(current_path).to eq("/profile/orders/#{order_1.id}")
    end

    visit "/profile/orders"
    within "#orders-#{order_2.id}" do
      expect(page).to have_content("Order ID: #{order_2.id}")
      expect(page).to have_content("Creation Date: #{order_2.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content("Last Updated: #{order_2.updated_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content('Status: pending')
      expect(page).to have_content('Number of Items: 3')
      expect(page).to have_content('Grand Total: $675.05')

      click_link "#{order_2.id}"

      expect(current_path).to eq("/profile/orders/#{order_2.id}")
    end

    visit "/profile/orders"
    within "#orders-#{order_3.id}" do
      expect(page).to have_content("Order ID: #{order_3.id}")
      expect(page).to have_content("Creation Date: #{order_3.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content("Last Updated: #{order_3.updated_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content('Status: pending')
      expect(page).to have_content('Number of Items: 1')
      expect(page).to have_content('Grand Total: $450.00')

      click_link "#{order_3.id}"

      expect(current_path).to eq("/profile/orders/#{order_3.id}")
    end
  end
end
