class Place < ApplicationRecord

  def self.search(search)
    if search
      Place.where(['area LIKE ?', "%#{search}%"])
    else
      Place.all
    end
  end

end
