class CreateSqliteUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :sqlite3_users do |t|
      t.timestamps
    end
  end
end
