require 'rails_helper'

describe 'merchant adds an item' do
  before(:each) do
    a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")
    merchant_admin = a_latte_fun.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

    chai_latte = a_latte_fun.items.create(name: "Chai Latte", description: "So yummy!", price: 4.50, image: "https://i.imgur.com/G5powzX.jpg", inventory: 10)
    pumpkin_loaf = a_latte_fun.items.create(name: "Pumpkin Spice Loaf", description: "Warm and tasty!", price: 5.00, image: "https://i.imgur.com/Q3dEKCn.jpg", inventory: 7)

    visit '/'
    click_link 'Login'
    fill_in :email, with: merchant_admin.email
    fill_in :password, with: merchant_admin.password
    click_button 'Log In'

    visit "/merchant/items"

    click_link 'Add New Item'
  end
  it 'merchant adds an item from their items page' do

    expect(current_path).to eq('/merchant/items/new')

    fill_in :name, with: 'Hot Chocolate'
    fill_in :description, with: 'Delicious dark hot chocolate topped with whipped cream.'
    fill_in :price, with: 3.50
    fill_in :image, with:  "https://i.imgur.com/cDI4mCQ.jpg"
    fill_in :inventory, with: 500
    click_button 'Add Item'

    hot_coco = Item.last

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Hot Chocolate is saved to your items.')
    expect(page).to have_css("#item-#{hot_coco.id}")
    expect(hot_coco.active?).to eq(true)
  end
  it 'merchant can add item without a photo that will be given a placeholder image' do

    expect(current_path).to eq('/merchant/items/new')

    fill_in :name, with: 'Apple Strudel'
    fill_in :description, with: "Just as good as grandma's."
    fill_in :price, with: 6.00
    fill_in :inventory, with: 40
    click_button 'Add Item'

    apple_strudel = Item.last

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Apple Strudel is saved to your items.')
    expect(page).to have_css("#item-#{apple_strudel.id}")
    expect(apple_strudel.active?).to eq(true)
    expect(page).to have_css("img[src*='data:image/png;base64,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']")

  end

  it 'merchant cannot add item without name' do

    fill_in :name, with: ''
    fill_in :description, with: 'Warm spice black tea with steamed milk'
    fill_in :price, with: 4.00
    fill_in :inventory, with: 50
    click_button 'Add Item'


    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("Name can't be blank")
    expect(find_field('Description').value).to eq 'Warm spice black tea with steamed milk'
    expect(find_field('Price').value).to eq('4.0')
    expect(find_field('Inventory').value).to eq('50')
    end
  it 'merchant cannot add item without description' do

    fill_in :name, with: 'Chai Latte'
    fill_in :description, with: ''
    fill_in :price, with: 4.00
    fill_in :inventory, with: 50
    click_button 'Add Item'

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("Description can't be blank")
    expect(find_field('Name').value).to eq "Chai Latte"
    expect(find_field('Price').value).to eq('4.0')
    expect(find_field('Inventory').value).to eq('50')
  end
  it 'merchant must add item with price greater than zero' do

    fill_in :name, with: 'Chai Latte'
    fill_in :description, with: 'Warm spice black tea with steamed milk'
    fill_in :price, with: -4.00
    fill_in :inventory, with:('50')
    click_button 'Add Item'

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Price must be greater than 0')
    expect(find_field('Name').value).to eq "Chai Latte"
    expect(find_field('Description').value).to eq 'Warm spice black tea with steamed milk'
    expect(find_field('Price').value).to eq('-4.0')
    expect(find_field('Inventory').value).to eq('50')

  end
  it 'merchant must add item with inventory greater than zero' do

    fill_in :name, with: 'Chai Latte'
    fill_in :description, with: 'Warm spice black tea with steamed milk'
    fill_in :price, with: 4.00
    fill_in :inventory, with: -50
    click_button 'Add Item'

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content('Inventory must be greater than 0')
    expect(find_field('Name').value).to eq "Chai Latte"
    expect(find_field('Description').value).to eq 'Warm spice black tea with steamed milk'
    expect(find_field('Price').value).to eq('4.0')


  end
end
