require 'rails_helper'


describe 'admin can edit user profile and password' do
  before(:each) do
    @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'
  end

  it "can edit default user profile" do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Edit Profile"
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")

    expect(find_field('Name').value).to eq "Richy Rich"
    expect(find_field('Email').value).to eq "young_money99@gmail.com"

    fill_in 'Name', with: "Poory Poor"
    fill_in 'Email', with: "old_money99@gmail.com"

    click_button 'Submit Changes'

    expect(current_path).to eq('/admin/users')

    within "#users-#{@user_1.id}" do
      expect(current_path).to eq('/admin/users')
      expect(page).to have_content("Poory Poor")
      expect(page).to have_content("old_money99@gmail.com")
    end
  end

  it "can edit default user password" do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Edit Password"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit/password")

    expect(page).to have_field('Password')
    expect(page).to have_field('Password confirmation')

    fill_in 'Password', with: "newpasswordwhodis"
    fill_in 'Password confirmation', with: "newpasswordwhodis"
    click_button 'Submit Changes'

    @user_1.reload

    expect(current_path).to eq('/admin/users')
    expect(page).to have_content("You have successfully updated #{@user_1.name}'s password!")

    click_link 'Log Out'

    visit '/'
    click_link 'Login'

    fill_in :email, with: @user_1.email
    fill_in :password, with: 'newpasswordwhodis'
    click_button 'Log In'
    expect(current_path).to eq("/profile/#{@user_1.id}")
    expect(page).to have_content('Welcome, Richy Rich! You are logged in.')
  end

  it "Tells me when password form doesnt match" do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Edit Password"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit/password")

    fill_in 'Password', with: "apple"
    fill_in 'Password confirmation', with: "orange"
    click_button 'Submit Changes'

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit/password")
    expect(page).to have_content("Password confirmation doesn't match Password")

    fill_in 'Password', with: "apple"
    fill_in 'Password confirmation', with: "apple"
    click_button 'Submit Changes'
    @user_1.reload

    expect(current_path).to eq('/admin/users')
    expect(page).to have_content("You have successfully updated #{@user_1.name}'s password!")
  end

  it "Wont let me use invalid info for updating user profile." do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Edit Profile"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")

    fill_in 'Name', with: ""
    fill_in 'Email', with: "old_money99@gmail.com"
    click_button 'Submit Changes'

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")
    expect(page).to have_content("Name can't be blank")

    expect(find_field('Name').value).to eq "Richy Rich"
    expect(find_field('Email').value).to eq "young_money99@gmail.com"

    fill_in 'Name', with: " "
    click_button 'Submit Changes'
    expect(page).to have_content("Name can't be blank")
  end

  it "Wont let me use existing email for updating user profile." do
    visit '/admin/users'

    within "#users-#{@user_1.id}" do
      click_link "Edit Profile"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")

    fill_in 'Email', with: "alice_in_the_sky@gmail.com"
    click_button 'Submit Changes'

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit")
    expect(page).to have_content('Email has already been taken')

    expect(find_field('Name').value).to eq "Richy Rich"
    expect(find_field('Email').value).to eq "young_money99@gmail.com"
  end
end
