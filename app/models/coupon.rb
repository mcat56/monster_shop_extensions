class Coupon < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :percent


end
