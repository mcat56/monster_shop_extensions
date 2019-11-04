class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, uniqueness: true
  validates_presence_of :name, :percent


end
