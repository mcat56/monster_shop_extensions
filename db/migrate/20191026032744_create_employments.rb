class CreateEmployments < ActiveRecord::Migration[5.1]
  def change
    create_table :employments do |t|
      t.references :user, foreign_key: true
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
