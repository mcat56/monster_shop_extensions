require 'rails_helper'

describe "As a regular User" do
  describe "When I visit my profile page" do
    before :each do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @address_1 = @user.addresses.create(street: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701')
    end

    it "Displays my profile data and a link to edit my profile." do
      visit '/'

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      visit "/profile/#{@user.id}"

      expect(page).to_not have_link('My Orders')
      expect(page).to have_content('Hello, Patti!')
      expect(page).to have_content('E-mail: pattimonkey34@gmail.com')
      expect(page).to have_link('Edit Profile')
      click_link 'Edit Profile'

      expect(current_path).to eq("/profile/#{@user.id}/edit")
    end
    it 'shows merchant profile' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      merchant_user = meg.users.create!(name: 'Leslie', email: 'leslieknope@gmail.com', password: 'waffles', role: 1)

      visit '/'

      click_link 'Login'

      fill_in :email, with: merchant_user.email
      fill_in :password, with: merchant_user.password
      click_button 'Log In'

      visit "/profile/#{merchant_user.id}"

      expect(page).to have_content('Hello, Leslie!')
    end
    it 'can link to order show page' do
      order_1 = @user.orders.create!(name: 'Richy Rich', address: @address_1)
      order_2 = @user.orders.create!(name: 'Alice Wonder', address: @address_1)
      order_3 = @user.orders.create!(name: 'Sonny Moore', address: @address_1)
      visit '/'

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      visit "/profile/#{@user.id}"

      click_link 'My Orders'

      expect(current_path).to eq("/profile/orders")
    end
  end
end
