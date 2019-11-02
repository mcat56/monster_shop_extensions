require 'rails_helper'

describe 'user can see all of their addresses' do
  describe 'they click a link for their address index page on their profile' do
    it 'displays all user addresses' do
      user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
      address_1 = user.addresses.create(address: '234 Orange Ave', city: 'Orangeburg', state: 'NY', zip: '10962')
      address_2 = user.addresses.create(nickname: 'work', address: '65 Work Street', city: 'Orangeburg', state: 'NY', zip: '10962')
      address_3 = user.addresses.create(nickname: 'parents', address: '2034 Nostalgia Place', city: 'Nyack', state: 'NY', zip: '10960')

      visit '/'
      click_link 'Login'
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'

      click_link 'My Addresses'

      expect(current_path).to eq("/users/#{user.id}/addresses")
      expect(page).to have_content("Patti's Addresses")

      within "#address-#{address_1.id}" do
        expect(page).to have_link "#{address_1.nickname}"
        expect(page).to have_content('234 Orange Ave')
        expect(page).to have_content('Orangeburg')
        expect(page).to have_content('NY')
        expect(page).to have_content('10962')
      end

      within "#address-#{address_2.id}" do
        expect(page).to have_link "#{address_2.nickname}"
        expect(page).to have_content('65 Work Street')
        expect(page).to have_content('Orangeburg')
        expect(page).to have_content('NY')
        expect(page).to have_content('10962')
      end

      within "#address-#{address_3.id}" do
        expect(page).to have_link "#{address_3.nickname}"
        expect(page).to have_content('2034 Nostalgia Place')
        expect(page).to have_content('Nyack')
        expect(page).to have_content('NY')
        expect(page).to have_content('10960')
      end
    end
  end
end 
