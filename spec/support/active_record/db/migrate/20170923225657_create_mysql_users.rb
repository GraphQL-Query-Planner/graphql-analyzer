class CreateMysqlUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :mysql_users do |t|
      t.timestamps
    end
  end
end
