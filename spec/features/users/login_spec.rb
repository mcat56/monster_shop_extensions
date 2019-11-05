require 'rails_helper'


describe 'Login' do
  describe "as a User" do
    before(:each) do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    end
    it 'can log in with valid credentials' do

      visit '/'

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'


      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('Welcome, Patti! You are logged in.')
      expect(page).to have_content('E-mail: pattimonkey34@gmail.com')
    end

    it 'cannot log in with invalid credentials' do

      visit '/'

      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: 'monkeyingaround'
      click_button 'Log In'

      expect(current_path).to eq('/login')
      expect(page).to have_content('Credentials were incorrect.')
    end
    it 'cannot login with an email that has not been  registered' do
      visit '/'

      click_link 'Login'

      fill_in :email, with: 'wheriswaldo@gmail.com'
      fill_in :password, with: 'nobodyknows'
      click_button 'Log In'

      expect(current_path).to eq('/login')
      expect(page).to have_content('Please register')
    end
    it 'redirects to profile if I am already logged in' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/login'

      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('You are already logged in.')
    end
  end

  describe "as a Merchant User" do
    it "can login with valid credentials" do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      merchant_user = meg.users.create!(name: 'Leslie', email: 'leslieknope@gmail.com', password: 'waffles', role: 1)

      visit '/'

      click_link 'Login'

      fill_in :email, with: merchant_user.email
      fill_in :password, with: merchant_user.password
      click_button 'Log In'

      expect(current_path).to eq("/merchant")
      expect(page).to have_content('Welcome, Leslie! You are logged in.')
      expect(page).to have_content("Employer: Meg's Bike Shop")
      expect(page).to have_content('Address: 123 Bike Rd')
      expect(page).to have_content('City: Denver')
      expect(page).to have_content('State: CO')
      expect(page).to have_content('Zip Code: 80203')
    end
    it 'redirects to merchant dashboard if I am already logged in' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_user = meg.users.create!(name: 'Leslie', email: 'leslieknope@gmail.com', password: 'waffles', role: 1)
      visit '/'

      click_link 'Login'

      fill_in :email, with: merchant_user.email
      fill_in :password, with: merchant_user.password
      click_button 'Log In'

      visit '/login'

      expect(current_path).to eq("/merchant")
      expect(page).to have_content('You are already logged in.')
    end
  end

  describe "as an Admin User" do
    it "can login with valid credentials" do
      admin_user = User.create!(name: 'Sabrina', email: 'spellcaster23@gmail.com', password: 'salem', role: 3)
      address = admin_user.addresses.create!(street: '66 Witches Way', city: 'Greendale', state: 'West Virginia', zip: '26210')
      visit '/'

      click_link 'Login'

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password
      click_button 'Log In'

      expect(current_path).to eq("/admin")
      expect(page).to have_content('Welcome, Sabrina! You are logged in.')
      expect(page).to have_content('home')
      expect(page).to have_content('Address: 66 Witches Way')
      expect(page).to have_content('City: Greendale')
      expect(page).to have_content('State: West Virginia')
      expect(page).to have_content('Zip Code: 26210')
      expect(page).to have_content('E-mail: spellcaster23@gmail.com')
    end
    it 'redirects to merchant dashboard if I am already logged in' do
      admin_user = User.create!(name: 'Sabrina', email: 'spellcaster23@gmail.com', password: 'salem', role: 3)
      visit '/'

      click_link 'Login'

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password
      click_button 'Log In'

      visit '/login'

      expect(current_path).to eq("/admin")
      expect(page).to have_content('You are already logged in.')
    end
  end

end
