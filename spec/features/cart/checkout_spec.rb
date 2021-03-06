require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    it 'if I am not logged in I cannot checkout' do
      visit "/cart"

      expect(page).to have_content('You must login or register to check out.')
      expect(page).to_not have_link("Checkout")

    end
    it 'User can checkout if they are logged in' do
      visit '/'
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      click_link 'Login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'

      visit "/cart"
      click_link "Checkout with Existing Address"

      expect(current_path).to eq("/orders/new")
    end
    it 'user cannot checkout with an address' do
      visit '/'
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      click_link 'Login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'
      visit '/cart'
      expect(page).to have_content('You cannot checkout without an existing address. Click link to Add Address')
      expect(page).to_not have_link("Checkout with Existing Address")

      click_link 'Add Address'

      expect(current_path).to eq("/users/#{user.id}/addresses/new")
    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit '/'
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')

      click_link 'Login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'

      visit "/cart"

      expect(page).to_not have_link("Checkout with Existing Address")
    end
  end
end
