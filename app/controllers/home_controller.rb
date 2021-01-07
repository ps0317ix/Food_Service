require "open-uri"
require "nokogiri"

class HomeController < ApplicationController

  def index
    # @allPlaces = Place.all
    # if @allPlaces
      @tabelogUrl = 'https://tabelog.com/tokyo/rstLst/?SrtT=rt&Srt=D&sort_mode=1'
      charset = nil
      html = open(@tabelogUrl) do |page|
        #charsetを自動で読み込み、取得
        charset = page.charset
        #中身を読む
        page.read
      end
      @tabelogDoc = Nokogiri::HTML(open(@tabelogUrl))
      @tabelogContents = @tabelogDoc.xpath("//div[@class='list-rst__wrap js-open-new-window']")

      # @ikkyuUrl = 'https://restaurant.ikyu.com/area/tokyo/'
      # charset = nil
      # html = open(@ikkyuUrl) do |page|
      #   #charsetを自動で読み込み、取得
      #   charset = page.charset
      #   #中身を読む
      #   page.read
      # end
      # @ikkyuDoc = Nokogiri::HTML(open(@ikkyuUrl))
      # @ikkyuContents = @ikkyuDoc.xpath("//section[@class='restaurantCard_jpBMy']")
    # end
  end
end
