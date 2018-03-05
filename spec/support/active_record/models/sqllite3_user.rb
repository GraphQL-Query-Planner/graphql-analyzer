class Sqlite3User < ApplicationRecord
  establish_connection DB_CONFIGS['sqlite3'][RAILS_ENV]
end
