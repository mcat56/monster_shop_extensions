require 'rails_helper'

describe 'a user can see an address show page' do
  before(:each) do
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    @address_1 = @user.addresses.create(street: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')

    visit '/'
    click_link 'Login'
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'
  end
  it 'they click a link on their profile' do

    within "#address-#{@address_1.id}" do
      click_link "#{@address_1.nickname}"
    end

    expect(current_path).to eq("/users/#{@user.id}/addresses/#{@address_1.id}")
    expect(page).to have_content('Home')
    expect(page).to have_content('234 Orange Ave')
    expect(page).to have_content('Orangeburg')
    expect(page).to have_content('NY')
    expect(page).to have_content('10962')
  end
end
