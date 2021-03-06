require 'rails_helper'

describe Address do
  describe 'validations' do
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
  end
  describe 'attributes' do
    it 'has attributes' do
      patti = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      address = patti.addresses.create(street: '87 Beach Way', city: 'Miami', state: 'Florida', zip: '33130')

      expect(address.street).to eq('87 Beach Way')
      expect(address.city).to eq('Miami')
      expect(address.state).to eq('Florida')
      expect(address.zip).to eq('33130')
    end
  end
  describe 'instance methods' do
    it 'get full address' do
      patti = User.create(name: 'Patti', email: 'pattimonkey34@gmail.com', password: 'banana')

      address = patti.addresses.create(street: '87 Beach Way', city: 'Miami', state: 'Florida', zip: '33130')

      expect(address.get_full_address).to eq('Home: 87 Beach Way Miami Florida 33130')
    end
  end
end
