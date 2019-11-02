require 'rails_helper'

RSpec.describe "Admin Users Index" do
  before(:each) do
    @admin = User.create!(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create!(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create!(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create!(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    suite_deal= Merchant.create(name: "Suite Deal Home Goods", address: '1280 Park Ave', city: 'Denver', state: 'CO', zip: "80202")
    knit_wit = Merchant.create(name: "Knit Wit", address: '123 Main St.', city: 'Denver', state: 'CO', zip: "80218")
    a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")

    dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @merchant_employee = dog_shop.users.create!(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 1)


    pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @merchant_admin = pawty_city.users.create!(name: 'Monicahh', email: 'anothercleaner@gmail.com', password: 'monmon', role: 2)


    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'
  end

  it "I can see all default users with their info, date registered, and perform the following actions:
   - link to their show page
   - edit user profile
   - edit user password
   - upgrade a user to a merchant account" do

    visit '/'
    click_link 'All Users'
    expect(current_path).to eq('/admin/users')

    within "#users-#{@user_1.id}" do
      expect(page).to have_link(@user_1.name)
      expect(page).to have_content(@user_1.role.gsub('_', ' ').capitalize)
      expect(page).to have_content(@user_1.email)
      expect(page).to have_link("Edit Profile")
      expect(page).to have_link("Edit Password")
      expect(page).to have_link("Upgrade to Merchant User")

      click_link "Edit Profile"
      expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")
    end

    visit '/admin/users'
    within "#users-#{@user_1.id}" do
      click_link "Edit Password"
      expect(current_path).to eq("/admin/users/#{@user_1.id}/edit/password")
    end

    visit '/admin/users'
    within "#users-#{@user_1.id}" do
      click_link "#{@user_1.name}"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}")
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_link('Edit Password')
    expect(page).to_not have_content('Edit')
    expect(page).to_not have_content('edit')

    ##User 2##
    visit '/admin/users'
    within "#users-#{@user_2.id}" do
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_2.created_at.to_date)
      expect(page).to have_content(@user_2.role.gsub('_', ' ').capitalize)
      expect(page).to have_content(@user_2.email)
      expect(page).to have_link("Edit Profile")
      expect(page).to have_link("Edit Password")
      expect(page).to have_link("Upgrade to Merchant User")

      click_link "Edit Profile"
      expect(current_path).to eq("/admin/users/#{@user_2.id}/edit")
    end

    visit '/admin/users'
    within "#users-#{@user_2.id}" do
      click_link "Edit Password"
      expect(current_path).to eq("/admin/users/#{@user_2.id}/edit/password")
    end

    visit '/admin/users'
    within "#users-#{@user_2.id}" do
      click_link "#{@user_2.name}"
    end

    expect(current_path).to eq("/admin/users/#{@user_2.id}")
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_link('Edit Password')
    expect(page).to_not have_content('Edit')
    expect(page).to_not have_content('edit')

    ##User 3##
    visit '/admin/users'
    within "#users-#{@user_3.id}" do
      expect(page).to have_link(@user_3.name)
      expect(page).to have_content(@user_3.created_at.to_date)
      expect(page).to have_content(@user_3.role.gsub('_', ' ').capitalize)
      expect(page).to have_content(@user_3.email)
      expect(page).to have_link("Edit Profile")
      expect(page).to have_link("Edit Password")
      expect(page).to have_link("Upgrade to Merchant User")

      click_link "Edit Profile"
      expect(current_path).to eq("/admin/users/#{@user_3.id}/edit")
    end

    visit '/admin/users'
    within "#users-#{@user_3.id}" do
      click_link "Edit Password"
      expect(current_path).to eq("/admin/users/#{@user_3.id}/edit/password")
    end

    visit '/admin/users'
    within "#users-#{@user_3.id}" do
      click_link "#{@user_3.name}"
    end

    expect(current_path).to eq("/admin/users/#{@user_3.id}")
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_link('Edit Password')
    expect(page).to_not have_content('Edit')
    expect(page).to_not have_content('edit')

    ##User 4##
    visit '/admin/users'
    within "#users-#{@merchant_employee.id}" do
      expect(page).to have_link(@merchant_employee.name)
      expect(page).to have_content(@merchant_employee.created_at.to_date)
      expect(page).to have_content(@merchant_employee.role.gsub('_', ' ').capitalize)
      expect(page).to have_content(@merchant_employee.email)
      expect(page).to have_link("Edit Profile")
      expect(page).to have_link("Edit Password")
      expect(page).to_not have_link("Upgrade to Merchant User")

      click_link "Edit Profile"
      expect(current_path).to eq("/admin/users/#{@merchant_employee.id}/edit")
    end

    visit '/admin/users'
    within "#users-#{@merchant_employee.id}" do
      click_link "Edit Password"
      expect(current_path).to eq("/admin/users/#{@merchant_employee.id}/edit/password")
    end

    visit '/admin/users'
    within "#users-#{@merchant_employee.id}" do
      click_link "#{@merchant_employee.name}"
    end

    expect(current_path).to eq("/admin/users/#{@merchant_employee.id}")
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_link('Edit Password')
    expect(page).to_not have_content('Edit')
    expect(page).to_not have_content('edit')

    ##User 5##
    visit '/admin/users'
    within "#users-#{@merchant_admin.id}" do
      expect(page).to have_link(@merchant_admin.name)
      expect(page).to have_content(@merchant_admin.created_at.to_date)
      expect(page).to have_content(@merchant_admin.role.gsub('_', ' ').capitalize)
      expect(page).to have_content(@merchant_admin.email)
      expect(page).to have_link("Edit Profile")
      expect(page).to have_link("Edit Password")
      expect(page).to_not have_link("Upgrade to Merchant User")

      click_link "Edit Profile"
      expect(current_path).to eq("/admin/users/#{@merchant_admin.id}/edit")
    end

    visit '/admin/users'
    within "#users-#{@merchant_admin.id}" do
      click_link "Edit Password"
      expect(current_path).to eq("/admin/users/#{@merchant_admin.id}/edit/password")
    end

    visit '/admin/users'
    within "#users-#{@merchant_admin.id}" do
      click_link "#{@merchant_admin.name}"
    end

    expect(current_path).to eq("/admin/users/#{@merchant_admin.id}")
    expect(page).to_not have_link('Edit Profile')
    expect(page).to_not have_link('Edit Password')
    expect(page).to_not have_content('Edit')
    expect(page).to_not have_content('edit')

  end

  it "Doesn't let regular users see 'All Users'" do

    click_link 'Log Out'
    visit '/'
    click_link 'Login'
    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_button 'Log In'

    within ".topnav" do
      expect(page).to_not have_link('All Users')
    end

    visit '/admin/users'
    expect(page).to have_content('404')
  end
end
