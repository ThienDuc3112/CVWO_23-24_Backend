class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :colour
      t.timestamps
    end
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    create_table :posts do |t|
      t.string :username
      t.string :title
      t.text :content
      t.integer :upvotes
      t.references :category, null: false, foreign_key: true
      t.date :timestamp
      t.timestamps
    end
    create_table :posts_tags, id:false do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
    end
    add_index :posts_tags, [:tag_id, :post_id], unique:true
  end
end
