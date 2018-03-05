class PgUser < ApplicationRecord
  establish_connection DB_CONFIGS['postgresql'][RAILS_ENV]
end
