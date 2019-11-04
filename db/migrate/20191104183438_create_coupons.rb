class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.float :percent
      t.references :merchant, foreign_key: true
    end
  end
end
