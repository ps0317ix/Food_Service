require "geocoder"

class Shop < ApplicationRecord

  geocoded_by :address
  after_validation :geocode

  def self.shopjenre(tabelogshops)
    @tabelogshopjenre  = []
    tabelogshops.each do |shop|
      if shop.jenre != nil
        @shop = shop.jenre
        if @shop.match('、')
          @shopjenres = @shop.split('、')
          @shopjenres.each do |shopjenre|
            @tabelogshopjenre.push(shopjenre)
          end
        else
          @tabelogshopjenre.push(@shop)
        end
      end
    end
    return @tabelogshopjenre
  end

end
