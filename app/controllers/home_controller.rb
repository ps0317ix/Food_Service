require "open-uri"
require "nokogiri"

class HomeController < ApplicationController

  def index
    @allPlaces = Place.all
    @tabelogPlaces = Place.where(service: "食べログ")
    @ikkyuPlaces = Place.where(service: "一休")

    @tabelogshops = Shop.where(service: "食べログ")
    @ikkyushops = Shop.where(service: "一休")
    @placeinfo = @allPlaces.find_by(service: "食べログ")
  end
end
