class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false

      t.timestamps

      t.index [:last_name, :first_name]
      t.index [:email]
    end
  end
end
