require 'rails_helper'

describe 'a user can edit an address from the address show page' do
  before(:each) do
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(address: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')

    visit '/'
    click_link 'Login'
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'
  end
  it 'clicks edit link and fills out form' do

    within "#address-#{@address_1.id}" do
      click_link 'Edit Address'
    end

    expect(current_path).to eq("/users/#{@user.id}/addresses/#{@address_1.id}/edit")

    expect(find_field('Nickname').value).to eq 'home'
    expect(find_field('Address').value).to eq '234 Orange Ave'
    expect(find_field('City').value).to eq 'Orangeburg'
    expect(find_field('State').value).to eq 'NY'
    expect(find_field('Zip').value).to eq '10962'

    fill_in 'Nickname', with: 'home'
    fill_in 'Address', with: '798 Freedom St'
    fill_in 'City', with: 'Seattle'
    fill_in 'State', with: 'WA'
    fill_in 'Zip', with: '98101'
    click_button 'Update Address'

    expect(page).to have_content('Your address has been updated')
    expect(current_path).to eq("/users/#{@user.id}/addresses")

    within "#address-#{@address_1.id}" do
      expect(page).to have_content('home')
      expect(page).to have_content('798 Freedom St')
      expect(page).to have_content('Seattle')
      expect(page).to have_content('WA')
      expect(page).to have_content('98101')
    end
  end
  it 'user cannot update address without filling out all fields' do

    within "#address-#{@address_1.id}" do
      click_link 'Edit Address'
    end

    fill_in 'Nickname', with: 'home'
    fill_in 'Address', with: ''
    fill_in 'City', with: ''
    fill_in 'State', with: 'WA'
    fill_in 'Zip', with: '98101'
    click_button 'Update Address'

    expect(page).to have_content("Address can't be blank and City can't be blank")
    expect(current_path).to eq("/users/#{@user.id}/addresses/#{@address_1.id}/edit")
  end
end
