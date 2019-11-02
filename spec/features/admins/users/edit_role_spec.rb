require 'rails_helper'

RSpec.describe "Admin change User roles" do
  before(:each) do
    @admin = User.create(name: 'Monica', email: 'cleaner@gmail.com', password: 'monmon', role: 3)
    @user_1 = User.create(name: 'Richy Rich', email: "young_money99@gmail.com", password: "momoneymoprobz")
    @user_2 = User.create(name: 'Alice Wonder', email: "alice_in_the_sky@gmail.com", password: "cheshirecheezin")
    @user_3 = User.create(name: 'Sonny Moore', email: "its_always_sonny@gmail.com", password: "beatz")

    @suite_deal = Merchant.create(name: "Suite Deal Home Goods", address: '1280 Park Ave', city: 'Denver', state: 'CO', zip: "80202")
    @knit_wit = Merchant.create(name: "Knit Wit", address: '123 Main St.', city: 'Denver', state: 'CO', zip: "80218")
    @a_latte_fun = Merchant.create(name: "A Latte Fun", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")

    visit '/'
    click_link 'Login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'
  end

  it "can upgrade default user to merchant user" do
    visit '/admin/users'
    expect(@user_1.role).to eq("default")

    within "#users-#{@user_1.id}" do
      click_link "Upgrade to Merchant User"
    end

    expect(current_path).to eq("/admin/users/#{@user_1.id}/edit_role")

    page.has_select?('merchant', options: ["#{@suite_deal.name}", "#{@knit_wit.name}", "#{@a_latte_fun.name}"])
    page.has_select?('role', options: ["Employee", "Admin"])

    select("#{@suite_deal.name}", from: 'merchant')
    select("Employee", from: 'role')
    click_on "Submit Change"

    @user_1.reload
    expect(@user_1.role).to eq("merchant_employee")

    visit '/admin/users'
    expect(@user_2.role).to eq("default")

    within "#users-#{@user_2.id}" do
      click_link "Upgrade to Merchant User"
    end
    expect(current_path).to eq("/admin/users/#{@user_2.id}/edit_role")

    page.has_select?('merchant', options: ["#{@suite_deal.name}", "#{@knit_wit.name}", "#{@a_latte_fun.name}"])
    page.has_select?('role', options: ["Employee", "Admin"])

    select("#{@suite_deal.name}", from: 'merchant')
    select("Employee", from: 'role')
    click_on "Submit Change"

    @user_2.reload
    expect(@user_2.role).to eq("merchant_employee")


    visit '/admin/users'
    expect(@user_3.role).to eq("default")

    within "#users-#{@user_3.id}" do
      click_link "Upgrade to Merchant User"
    end

    expect(current_path).to eq("/admin/users/#{@user_3.id}/edit_role")

    page.has_select?('merchant', options: ["#{@suite_deal.name}", "#{@knit_wit.name}", "#{@a_latte_fun.name}"])
    page.has_select?('role', options: ["Employee", "Admin"])

    select("#{@suite_deal.name}", from: 'merchant')
    select("Admin", from: 'role')
    click_on "Submit Change"

    @user_3.reload
    expect(@user_3.role).to eq("merchant_admin")
  end
end
