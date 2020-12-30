class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories, :id => false do |t|
      t.bigint :id, :primary_key => true
      t.string :name, :null => false
    end
  end
end
