class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :colour

      t.timestamps
    end
    create_table :threds do |t|
      t.string :title
      t.string :username
      t.text :content
      t.integer :upvotes

      t.references :category, null: false, foreign_key: true
      
      t.timestamps
    end
    create_table :followups do |t|
      t.text :content
      t.string :username
      t.integer :upvotes
      t.references :thred, null: false, foreign_key: true

      t.timestamps
    end
  end
end
