require "geocoder"

class Shop < ApplicationRecord

  geocoded_by :address
  after_validation :geocode

end
