class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :body
      t.references :author, null: false
      t.references :receiver, null: false

      t.timestamps
    end
  end
end
