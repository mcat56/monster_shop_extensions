require 'rails_helper'

describe 'Register' do
  it 'creates a new user' do

    visit '/'

    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: 'Marcel'
    fill_in :address, with: '56 Jungle Lane'
    fill_in :city, with: 'New York'
    fill_in :state, with: 'New York'
    fill_in :zip, with: '10012'
    fill_in :email, with: 'markymonkey23@gmail.com'
    fill_in :password, with: 'bananarama'
    fill_in :password_confirmation, with: 'bananarama'

    click_button 'Complete Registration'

    new_user = User.last

    expect(current_path).to eq("/profile/#{new_user.id}")
    expect(page).to have_content('You have registered successfully! You are now logged in as Marcel.')
    expect(page).to have_content('home')
    expect(page).to have_content('Hello, Marcel!')
    expect(page).to have_content('Address: 56 Jungle Lane')
    expect(page).to have_content('City: New York')
    expect(page).to have_content('State: New York')
    expect(page).to have_content('Zip Code: 10012')
  end

  it "cannot register a new user without all fields filled" do
    visit '/'

    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: ''
    fill_in :email, with: ''
    fill_in :password, with: 'bananarama'
    fill_in :password_confirmation, with: 'bananarama'

    click_button 'Complete Registration'

    expect(current_path).to eq('/users')
    expect(page).to have_content("Name can't be blank and Email can't be blank")
  end

  it "cannot register a new user without a unique email" do
    user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

    visit '/'

    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: 'Marcel'
    fill_in :address, with: '953 Sunshine Ave'
    fill_in :city, with: 'New York'
    fill_in :state, with: 'Hawaii'
    fill_in :zip, with: '10012'
    fill_in :email, with: 'pattimonkey34@gmail.com'
    fill_in :password, with: 'bananarama'
    fill_in :password_confirmation, with: 'bananarama'

    click_button 'Complete Registration'

    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has already been taken')

    expect(find_field('Name').value).to eq('Marcel')
    expect(find_field('Address').value).to eq('953 Sunshine Ave')
    expect(find_field('City').value).to eq('New York')
    expect(find_field('State').value).to eq('Hawaii')
    expect(find_field('Zip').value).to eq('10012')
    expect(find_field('Email').value).to eq(nil)
    expect(find_field('Password').value).to eq(nil)
  end

  it "cannot register a new user without matching password confirmation" do
    visit '/'

    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: 'Marcel'
    fill_in :address, with: '953 Sunshine Ave'
    fill_in :city, with: 'New York'
    fill_in :state, with: 'Hawaii'
    fill_in :zip, with: '10012'
    fill_in :email, with: 'pattimonkey34@gmail.com'
    fill_in :password, with: 'bananarama'
    fill_in :password_confirmation, with: 'applerama'

    click_button 'Complete Registration'

    expect(current_path).to eq('/users')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it 'registration creates default home address' do
    visit '/'

    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: 'Marcel'
    fill_in :address, with: '56 Jungle Lane'
    fill_in :city, with: 'New York'
    fill_in :state, with: 'New York'
    fill_in :zip, with: '10012'
    fill_in :email, with: 'markymonkey23@gmail.com'
    fill_in :password, with: 'bananarama'
    fill_in :password_confirmation, with: 'bananarama'

    click_button 'Complete Registration'

    new_user = User.last

    address = new_user.addresses.first
    expect(address.nickname).to eq('home')
    expect(address.address).to eq('56 Jungle Lane')
    expect(address.city).to eq('New York')
    expect(address.state).to eq('New York')
    expect(address.zip).to eq('10012')

  end
end
