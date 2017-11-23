class ApplicationRecord < ActiveRecord::Base
  include GlobalID::Identification

  self.abstract_class = true
end
