require 'rails_helper'

describe 'a user can edit an order' do
  it 'from show page links to edit form' do
    visit '/'
    @user = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')
    click_link 'Login'

    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50.00, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 25.05, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    shifter = bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 50.00, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 4)


    order_1 = @user.orders.create!(name: 'Richy Rich', street: '102 Main St', city: 'NY', state: 'New York', zip: '10221' )
    order_2 = @user.orders.create!(name: 'Alice Wonder', street: '346 Underground Blvd', city: 'NY', state: 'New York', zip: '10221' )
    order_3 = @user.orders.create!(name: 'Sonny Moore', street: '87 Electric Ave', city: 'NY', state: 'New York', zip: '10221' )

    visit "/profile/orders/#{order_1.id}"

    click_link 'Update with New Address'

    fill_in :name, with: 'Patti'
    fill_in :street, with: '957 Portland Ave'
    fill_in :city, with: 'Portland'
    fill_in :state, with: 'ME'
    fill_in :zip, with: '04019'
    click_button 'Update Order'

    order_1.reload

    expect(current_path).to eq('/profile/orders')
    expect(page).to have_content('Order information updated')
    expect(order_1.name).to eq('Patti')
    expect(order_1.street).to eq('957 Portland Ave')
    expect(order_1.city).to eq('Portland')
    expect(order_1.state).to eq('ME')
    expect(order_1.zip).to eq('04019')
  end
end
