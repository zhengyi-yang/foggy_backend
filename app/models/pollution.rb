class Pollution < ActiveRecord::Base
  validates_uniqueness_of :site_code
  validates_uniqueness_of :latitude, scope: :longitude
end
