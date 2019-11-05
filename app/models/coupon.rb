class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :orders
  validates :name, uniqueness: true
  validates_presence_of :name, :percent, :enabled?


end
