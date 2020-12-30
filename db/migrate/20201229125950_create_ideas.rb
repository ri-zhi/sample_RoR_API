class CreateIdeas < ActiveRecord::Migration[6.1]
  def change
    create_table :ideas, :id => false do |t|
      t.bigint :id, :primary_key => true
      t.text :body, :null => false
    end

    add_reference :ideas, :categories, :column => :category_id, :foreign_key => :id, :null => false

    # categories_id になってしまうため
    rename_column :ideas, :categories_id, :category_id
  end
end
