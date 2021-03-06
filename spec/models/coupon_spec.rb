require 'rails_helper'

describe Coupon do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :enabled? }
    it { should validate_presence_of :percent }
    it { should validate_uniqueness_of :name }
  end
  describe 'attributes' do
    it 'has attributes' do
      coupon = Coupon.create(name: 'SUMMER18', percent: 0.2)

      expect(coupon.name).to eq('SUMMER18')
      expect(coupon.enabled?).to eq(true)
      expect(coupon.percent).to eq(0.2)
    end
  end
end
