
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor.' do
    it "I see a nav bar with links to all pages" do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'
        expect(current_path).to eq('/')
      end
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
        click_link 'Cart: 0'
        expect(current_path).to eq('/cart')
        visit '/items'
        expect(page).to have_content("Cart: 0")
        click_link 'Cart: 0'
        expect(current_path).to eq('/cart')
      end
    end

    it 'I can see a link to log in on all pages' do
      visit '/merchants'

      within 'nav' do
        click_link "Login"
        expect(current_path).to eq('/login')
        visit '/items'
        click_link "Login"
        expect(current_path).to eq('/login')
      end
    end

    it 'I can see a link to register on all pages' do
      visit '/merchants'

      within 'nav' do
        click_link 'Register'
        expect(current_path).to eq('/register')
        visit '/items'
        click_link 'Register'
        expect(current_path).to eq('/register')
      end
    end

    it "I can't visit pages I'm not authorized for" do
      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin/users'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/profile/1'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a User.' do
    it 'I see the navbar with links with profile and Log Out, not login or register' do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      visit '/'

      click_link 'Login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'
      visit '/'

      within 'nav' do
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_content('Logged in as Patti')
        expect(page).to have_link('Log Out')
        expect(page).to have_link('Profile')
        expect(page).to_not have_content('Login')
        expect(page).to_not have_content('Register')

        click_link 'Profile'
        expect(current_path).to eq("/profile/#{user.id}")
        click_link 'Log Out'
        expect(current_path).to eq('/')
      end
    end

    it "I can't visit pages I'm not authorized for" do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      visit '/'
      click_link 'Login'

      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'

      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin/users'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a merchant' do
    it 'I see navbar with links to all pages, profile, logout, dashboard, not login or register' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)


      merchant = meg.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

      visit '/'
      click_link 'Login'

      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password
      click_button 'Log In'
      visit '/'


      within 'nav' do
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_content('Logged in as Ross')
        expect(page).to have_link('Log Out')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Dashboard')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')

        click_link 'Dashboard'
        expect(current_path).to eq("/merchant")
      end
    end

    it "I can't visit pages I'm not authorized for" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      merchant = meg.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)
      visit '/'
      click_link 'Login'

      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password
      click_button 'Log In'

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin/users'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As an Admin' do
    it "I see the regular navbar with addition of the 'Admin Dashboard' and 'All Users' links" do

      admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
      visit '/'
      click_link 'Login'

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Log In'
      visit '/'

      within 'nav' do
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_content('Logged in as Monica')
        expect(page).to have_link('Log Out')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Dashboard')
        expect(page).to have_link('All Users')
        expect(page).to_not have_link('Cart: 0')
        expect(page).to_not have_link('Login')
        expect(page).to_not have_link('Register')

        click_link 'Dashboard'
        expect(current_path).to eq("/admin")

        click_link 'All Users'
        expect(current_path).to eq('/admin/users')
      end
    end

    it "I can't visit pages I'm not authorized for" do
      admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
      visit '/'
      click_link 'Login'

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Log In'
      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/cart'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
