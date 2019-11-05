class Item < ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def adjusted_price(coupon)
    if coupon == nil
      self.price
    else
      coupon = Coupon.find(coupon)
      if coupon.merchant != self.merchant || coupon.enabled? == false
        self.price
      else
        self.price * (1 - coupon.percent)
      end
    end
  end

  def self.top_five_items
    Item.joins(:item_orders).select("items.name, items.id, sum(item_orders.quantity) AS total_quantity").group(:id).order("total_quantity desc").limit(5)
  end

  def self.bottom_five_items
    Item.joins(:item_orders).select("items.name, items.id, sum(item_orders.quantity) AS total_quantity").group(:id).order("total_quantity asc").limit(5)
  end

  def deactivate
    self.update_column(:active?, false)
  end

  def activate
    self.update_column(:active?, true)
  end
end
