class CreatePgUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :pg_users do |t|
      t.timestamps
    end
  end
end
