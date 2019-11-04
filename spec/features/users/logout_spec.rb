require 'rails_helper'

describe 'logout' do
  describe 'logs out sending to home page with a flash message and an empty cart' do
    it 'logs out a regular user' do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      visit '/'
      click_link 'Login'
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'

      expect(page).to have_content('Logged in as Patti')
      click_link 'Log Out'

      expect(current_path).to eq('/')
      expect(page).to have_content('You have been logged out.')
      expect(page).to_not have_content('Logged in as Patti')
      expect(page).to have_link('Cart: 0')
    end
    it 'logs out a merchant user' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      merchant_user = meg.users.create!(name: 'Leslie', email: 'leslieknope@gmail.com', password: 'waffles', role: 1)
      visit '/'
      click_link 'Login'
      fill_in :email, with: merchant_user.email
      fill_in :password, with: merchant_user.password
      click_button 'Log In'


      expect(page).to have_content('Logged in as Leslie')
      click_link 'Log Out'

      expect(current_path).to eq('/')
      expect(page).to_not have_content('Logged in as Leslie')
      expect(page).to have_content('You have been logged out.')
      expect(page).to have_link('Cart: 0')
    end
    it 'logs out an admin user' do
      admin_user = User.create!(name: 'Sabrina', email: 'spellcaster23@gmail.com', password: 'salem', role: 3)
      visit '/'
      click_link 'Login'
      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password
      click_button 'Log In'


      expect(page).to have_content('Logged in as Sabrina')
      click_link 'Log Out'

      expect(current_path).to eq('/')
      expect(page).to have_content('You have been logged out.')
      expect(page).to_not have_content('Logged in as Sabrina')
      expect(page).to have_link('Cart: 0')
    end
  end
end
