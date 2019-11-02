require 'rails_helper'

describe "As a regular User" do
  describe "When I visit my profile page and click link to edit profile" do
    before :each do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      @merchant = User.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "Prompts me to edit my profile with a form" do
      visit "/profile/#{@user.id}"
      click_link 'Edit Profile'

      expect(current_path).to eq("/profile/#{@user.id}/edit")
      expect(find_field('Name').value).to eq "Patti"
      expect(find_field('Email').value).to eq "pattimonkey34@gmail.com"

      fill_in 'Name', with: "Pat"
      fill_in 'Email', with: "patmonkey@gmail.com"

      click_button 'Submit Changes'

      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('Hello, Pat! You have successfully updated your profile.')
      expect(page).to have_content('E-mail: patmonkey@gmail.com')

      visit "/profile/#{@user.id}"
      click_link 'Edit Profile'

      fill_in 'Name', with: "Pattylicious"
      click_button 'Submit Changes'

      expect(page).to have_content('Hello, Pattylicious! You have successfully updated your profile.')
    end

    it "Won't let me use an email already being used" do
      visit "/profile/#{@user.id}"
      click_link 'Edit Profile'
      expect(current_path).to eq("/profile/#{@user.id}/edit")

      fill_in 'Email', with: "dinosaurs_rule@gmail.com"
      click_button 'Submit Changes'

      expect(current_path).to eq("/profile/#{@user.id}/edit")
      expect(page).to have_content('Email has already been taken')
    end
  end

  describe "When I visit my profile page and click link to edit password" do
    before :each do
      @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      visit '/'
      click_link 'Login'
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'
    end

    it "Prompts me to edit my password with a form" do
      visit "/profile/#{@user.id}"
      click_link 'Edit Password'

      expect(current_path).to eq("/profile/#{@user.id}/edit/password")

      expect(page).to have_field('Password')
      expect(page).to have_field('Password confirmation')

      fill_in 'Password', with: "apple"
      fill_in 'Password confirmation', with: "apple"
      click_button 'Submit Changes'

      expect(current_path).to eq("/profile/#{@user.id}")

      expect(page).to have_content("Hello, #{@user.name}! You have successfully updated your password.")

      click_link 'Log Out'
      click_link 'Login'

      fill_in :email, with: @user.email
      fill_in :password, with: 'apple'
      click_button 'Log In'
      expect(current_path).to eq("/profile/#{@user.id}")
      expect(page).to have_content('Welcome, Patti! You are logged in.')
    end

    it "Won't let me use a password that doesn't match" do
      visit "/profile/#{@user.id}"
      click_link 'Edit Password'

      fill_in 'Password', with: "apple"
      fill_in 'Password confirmation', with: "notanapple"
      click_button 'Submit Changes'

      expect(current_path).to eq("/profile/#{@user.id}/edit/password")
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
