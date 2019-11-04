require 'rails_helper'

RSpec.describe "merchant edits an item" do
  before(:each) do
    @a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")
    @merchant_admin = @a_latte_fun.users.create(name: 'Ross', email: 'dinosaurs_rule@gmail.com', password: 'rachel', role: 2)

    @chai_latte = @a_latte_fun.items.create(name: "Chai Latte", description: "So yummy!", price: 4.50, image: "https://i.imgur.com/G5powzX.jpg", inventory: 10)
    @pumpkin_loaf = @a_latte_fun.items.create(name: "Pumpkin Spice Loaf", description: "Warm and tasty!", price: 5.00, image: "https://i.imgur.com/Q3dEKCn.jpg", inventory: 7)

    visit '/'
    click_link 'Login'
    fill_in :email, with: @merchant_admin.email
    fill_in :password, with: @merchant_admin.password
    click_button 'Log In'

    visit "/merchant/items"
  end

  it "merchant can click an edit button that leads to a prepopulated form" do
    within "#item-#{@chai_latte.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@chai_latte.id}/edit")
    expect(find_field('Name').value).to eq "#{@chai_latte.name}"
    expect(find_field('Description').value).to eq "#{@chai_latte.description}"
    expect(find_field('Price').value).to eq "$4.50"
    expect(find_field('Image').value).to eq("https://i.imgur.com/G5powzX.jpg")
    expect(find_field('Inventory').value).to eq '10'

    visit '/merchant/items'

    within "#item-#{@pumpkin_loaf.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@pumpkin_loaf.id}/edit")
    expect(find_field('Name').value).to eq "#{@pumpkin_loaf.name}"
    expect(find_field('Description').value).to eq "#{@pumpkin_loaf.description}"
    expect(find_field('Price').value).to eq "$5.00"
    expect(find_field('Image').value).to eq("https://i.imgur.com/Q3dEKCn.jpg")
    expect(find_field('Inventory').value).to eq '7'
  end

  it "merchant can edit and update item with the form and gets success flash message when item is updated successfully" do
    visit '/merchant/items'

    within "#item-#{@chai_latte.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@chai_latte.id}/edit")
    expect(page).to have_content("Edit Chai Latte")
    fill_in 'Name', with: "Masala Chai"
    fill_in 'Description', with: "Just the right amount of spice"
    fill_in 'Price', with: 6
    fill_in 'Image', with: "https://www.ohhowcivilized.com/wp-content/uploads/2013/01/0918-cha-tea-latte-16.jpg"
    fill_in 'Inventory', with: 12

    click_button "Update Item"

    expect(current_path).to eq('/merchant/items')
    expect(page).to have_content("Your item has been updated")
    expect(page).to have_content('Masala Chai')
    expect(page).to_not have_content('Chai Latte')
    expect(page).to have_content('Just the right amount of spice')
    expect(page).to_not have_content('So yummy!')
    expect(page).to have_content('Price: $6.00')
    expect(page).to_not have_content('Price: $4.50')
    expect(page).to have_css("img[src*='https://www.ohhowcivilized.com/wp-content/uploads/2013/01/0918-cha-tea-latte-16.jpg']")
    expect(page).to_not have_css("img[src*='https://i.imgur.com/G5powzX.jpg']")
    expect(page).to have_content('Inventory: 12')
    expect(page).to_not have_content('Inventory: 10')
    expect(@chai_latte.active?).to eq(true)
  end

  it "merchant gets an error flash message and prepopulated form if the entire form except image isn't filled out" do
    visit '/merchant/items'

    within "#item-#{@chai_latte.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@chai_latte.id}/edit")
    expect(page).to have_content("Edit Chai Latte")
    fill_in 'Name', with: ""
    fill_in 'Description', with: ""
    fill_in 'Price', with: 6
    fill_in 'Image', with: "https://www.ohhowcivilized.com/wp-content/uploads/2013/01/0918-cha-tea-latte-16.jpg"
    fill_in 'Inventory', with: 12

    click_button "Update Item"

    expect(page).to have_content("Name can't be blank and Description can't be blank")
    expect(page).to have_button("Update Item")
  end

  it "merchant can edit item and leave image blank and it will be given a placeholder image" do
    visit '/merchant/items'

    within "#item-#{@chai_latte.id}" do
      click_link "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@chai_latte.id}/edit")
    expect(page).to have_content("Edit Chai Latte")
    fill_in 'Name', with: "Masala Chai"
    fill_in 'Description', with: "Just the right amount of spice"
    fill_in 'Price', with: 6
    fill_in 'Image', with: " "
    fill_in 'Inventory', with: 12

    click_button "Update Item"

    expect(page).to have_content("Masala Chai")
    expect(@chai_latte.active?).to eq(true)
    expect(page).to have_css("img[src*='data:image/png;base64,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']")
  end
end
