require 'rails_helper'


describe 'users can add a new address from their profile page' do
  before(:each) do
    visit '/'
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    click_link 'Login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

    click_link 'Add an Address'
  end
  it 'user links from profile to fill in new address form' do
    expect(current_path).to eq("/users/#{@user.id}/addresses/new")

    fill_in 'Nickname', with: 'work'
    fill_in 'Address', with: '28 Park Ave'
    fill_in 'City', with: 'Philadelphia'
    fill_in 'State', with: 'PA'
    fill_in 'Zip', with: '19103'
    click_button 'Create Address'

    expect(current_path).to eq("/profile/#{@user.id}")
    expect(page).to have_content('Your address has been added.')
    address = @user.addresses.last

    within "#address-#{address.id}" do
      expect(page).to have_content('work')
      expect(page).to have_content('Address: 28 Park Ave')
      expect(page).to have_content('City: Philadelphia')
      expect(page).to have_content('State: PA')
      expect(page).to have_content('Zip Code: 19103')
    end
  end
  it 'user cannot create address without filling out all fields' do
    expect(current_path).to eq("/users/#{@user.id}/addresses/new")

    fill_in 'Nickname', with: ''
    fill_in 'Address', with: '28 Park Ave'
    fill_in 'City', with: 'Philadelphia'
    fill_in 'State', with: 'PA'
    fill_in 'Zip', with: ''
    click_button 'Create Address'

    expect(current_path).to eq("/users/#{@user.id}/addresses/new")
    expect(page).to have_content("Nickname can't be blank and Zip can't be blank")
  end
end
