require 'rails_helper'

RSpec.describe "As an Admin" do
  describe "When I visit a merchant show page" do
    before(:each) do
      @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80204)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @pulltoy = @brian.items.create(name: "Pulltoy", description: "It'll never fall apart!", price: 14, image: "https://www.valupets.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/l/a/large_rubber_dog_pull_toy.jpg", inventory: 7)

      visit '/'
      click_link 'Login'
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button 'Log In'
    end

    it "Lets me delete merchants" do
      visit "/merchants/#{@meg.id}"
      expect(page).to have_link('Update Merchant')
      expect(page).to have_link('Delete Merchant')

      click_link 'Delete Merchant'

      expect(page).to have_content("You have successfully deleted the merchant #{@meg.name}")
      expect(page).to_not have_link("#{@meg.name}")
      expect(current_path).to eq('/merchants')
    end

    it "I can delete a merchant that has items" do
      visit "merchants/#{@bike_shop.id}"
      expect(page).to have_link("#{@bike_shop.name}")

      click_on "Delete Merchant"

      expect(current_path).to eq('/merchants')
      expect(page).to have_content("You have successfully deleted the merchant Brian's Bike Shop")
      expect(page).to_not have_link("#{@bike_shop.name}")
    end

    it "I can't delete a merchant that has orders" do
      click_link 'Log Out'
      click_link 'Login'
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'


      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout with New Address"

      name = "Bert"
      street = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :street, with: street
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      click_link 'Log Out'
      click_link 'Login'
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_button 'Log In'

      visit "/merchants/#{@meg.id}"
      expect(page).to_not have_link("Delete Merchant")
    end
  end
end
