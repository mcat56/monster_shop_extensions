require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit '/'
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'


      visit "/cart"
      click_on "Checkout with Existing Address"
    end

    it 'shows all order information' do

      select('Home: 953 Sunshine Ave Honolulu Hawaii 96701', from: 'address')
      click_button "Create Order"
      new_order = Order.last

      expect(current_path).to eq("/profile/orders/#{new_order.id}")
      expect(page).to have_content('Your order has been placed!')

      visit "/profile/orders/#{new_order.id}"

      within '.shipping-address' do
        expect(page).to have_content('Patti')
        expect(page).to have_content(@address_1.street)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_content("#{@paper.description}")
        expect(page).to have_css("img[src*='#{@paper.image}']")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
        expect(page).to have_link("#{@paper.merchant.name}")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content("#{@tire.description}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
        expect(page).to have_link("#{@tire.merchant.name}")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_content("#{@pencil.description}")
        expect(page).to have_css("img[src*='#{@pencil.image}']")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
        expect(page).to have_link("#{@pencil.merchant.name}")
      end

      expect(page).to have_content("Order ID: #{new_order.id}")

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at.to_formatted_s(:long_ordinal))
      end

      expect(page).to have_content("Last Updated: #{new_order.created_at.to_formatted_s(:long_ordinal)}")
      expect(page).to have_content('Status: pending')
      expect(page).to have_content('Total Items: 3')

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      expect(page).to have_link('Cancel Order')
    end
  end
end
