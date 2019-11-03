require 'rails_helper'

describe 'user can delete addresses' do
  before(:each) do
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(address: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')
    @address_2 = @user.addresses.create(nickname: 'work', address: '65 Work Street', city: 'Orangeburg', state: 'NY', zip: '10962')
    @address_3 = @user.addresses.create(nickname: 'parents', address: '2034 Nostalgia Place', city: 'Nyack', state: 'NY', zip: '10960')


    visit '/'
    click_link 'Login'
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

    click_link 'My Addresses'
  end
  it 'links from address show' do

    within "#address-#{@address_1.id}" do
      click_link "#{@address_1.nickname}"
    end

    click_link 'Delete Address'

    expect(current_path).to eq("/profile/#{@user.id}")
    expect(page).to have_content('Address deleted')
    expect(page).to_not have_css("#address-#{@address_1.id}")
  end
  it 'user cannot delete an address if there is a shipped order with that address' do
  end
end
