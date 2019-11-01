require 'rails_helper'

describe Address do
  describe 'validations' do
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end
  describe 'relationships' do
    it { should belong_to :user }
  end
  describe 'attributes' do
    it 'has attributes' do
      patti = User.create(name: 'Patti', address: '953 Sunshine Ave', city: 'Honolulu', state: 'Hawaii', zip: '96701', email: 'pattimonkey34@gmail.com', password: 'banana')

      address = patti.addresses.create(address: '87 Beach Way', city: 'Miami', state: 'Florida', zip: '33130')

      expect(address.address).to eq('87 Beach Way')
      expect(address.city).to eq('Miami')
      expect(address.state).to eq('Florida')
      expect(address.zip).to eq('33130')
    end
  end
end
