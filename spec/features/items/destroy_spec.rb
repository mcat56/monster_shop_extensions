require 'rails_helper'

RSpec.describe 'As a Merchant User', type: :feature do
  describe 'when I visit an item show page' do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @merchant_admin = @bike_shop.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)
      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      visit '/'
      click_link 'Login'
      fill_in :email, with: @merchant_admin.email
      fill_in :password, with: @merchant_admin.password
      click_button 'Log In'
      click_link 'All Merchants'
    end

    it 'I can delete an item' do
      visit "/items/#{@chain.id}"
      expect(page).to have_link("Delete Item")
      click_on "Delete Item"

      expect(current_path).to eq("/items")
      expect(Item.where(id:@chain.id)).to be_empty
    end

    it 'I can delete items and it deletes reviews' do
      visit "/items/#{@chain.id}"

      click_on "Delete Item"
      expect(Review.where(id:@review_1.id)).to be_empty
    end

    it 'I can not delete items with orders' do
      order_1 = @user.orders.create!(name: 'Meg', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80218)
      order_1.item_orders.create!(item: @chain, price: @chain.price, quantity: 2, merchant: @bike_shop)

      visit "/items/#{@chain.id}"

      expect(page).to_not have_link("Delete Item")
    end

    it "Regular User cannot delete Items" do
      click_link 'Log Out'
      visit "/items/#{@chain.id}"

      expect(page).to_not have_link("Delete Item")

      click_link 'Login'
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'
      visit "/items/#{@chain.id}"

      expect(page).to_not have_link("Delete Item")
    end
  end
end
