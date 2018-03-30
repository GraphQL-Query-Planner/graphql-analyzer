class MysqlUser < ApplicationRecord
  establish_connection DB_CONFIGS['mysql'][RAILS_ENV]
end