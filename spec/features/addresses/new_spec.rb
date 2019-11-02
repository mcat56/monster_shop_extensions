require 'rails_helper'


describe 'users can add a new address from their profile page' do
  it 'user links from profile to fill in new address form' do

    visit '/'

    user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')


    click_link 'Login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_link 'Add an Address'

    fill_in :nickname, with: 'work'
    fill_in :address, with: '28 Park Ave'
    fill_in :city, with: 'Philadelphia'
    fill_in :state, with: 'PA'
    fill_in :zip, with: '19103'
    click_button 'Create Address'

    expect(current_path).to eq("/profile/#{user.id}")

    address = user.addresses.last

    within "#address-#{address.id}" do
      expect(page).to have_content('work')
      expect(page).to have_content('Address: 28 Park Ave')
      expect(page).to have_content('City: Philadelphia')
      expect(page).to have_content('State: PA')
      expect(page).to have_content('Zip Code: 19103')
    end

  end
end
