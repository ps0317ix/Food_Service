require "open-uri"
require "nokogiri"
# require 'watir-webdriver'

class PlaceController < ApplicationController

  def index
    if params[:search]
      @places = Place.search(params[:search])
    else
      @places = Place.all
    end
  end

  # 新規登録
  def new
    @place = Place.new
  end


  def create

    @address = Geocoder.search(params[:area])
    link = params[:url]

    @place = Place.new(
      area: params[:area],
      url: link,
      service: params[:service],
      address: @address
    )


    if params[:service] == "食べログ"
      Place.tabelogScraping(params[:area], params[:service], link)
    elsif params[:service] == '一休'
      Place.ikkyuScraping(params[:area], params[:service], link)
    elsif params[:service] == 'Retty'
      Place.rettyScraping(params[:area], params[:service], link)
    end

    if @place.save
      flash[:notice] = "地域登録が完了しました"
      redirect_to("/place/#{@place.area}/ranking")
    else
      flash[:notice] = "地域登録が失敗しました"
      render("place/new")
    end
  end


  def edit
    @allPlaces = Place.all
  end

  def edit_shop
    @allPlaces = Place.all
    @allShops = Shop.where(area: params[:area])
    @allShopsAddress = Shop.where(area: params[:area]).where.not(address: nil)
  end


  def delete
    @place = Place.find_by(id: params[:id])
    @shops = Shop.where(area: @place.area).where(service: @place.service)
    @place.destroy
    if @shops.destroy_all
      flash[:notice] = "地域削除が完了しました"
      redirect_to("/place/edit")
    else
      flash[:notice] = "地域削除が失敗しました"
      render("/place/edit")
    end
  end


  def update
    @place = Place.find_by(id: params[:id])
    @shops = Shop.where(area: @place.area).where(service: @place.service)

    link = @place.url

    if @place.service == "食べログ"
      @shops.destroy_all
      Place.tabelogScraping(@place.area, @place.service, link)
    elsif @place.service == '一休'
      @shops.destroy_all
      Place.ikkyuScraping(@place.area, @place.service, link)
    elsif @place.service == 'Retty'
      @shops.destroy_all
      Place.rettyScraping(@place.area, @place.service, link)
    end

    flash[:notice] = "地域更新が完了しました"
    redirect_to("/place/#{@place.area}/edit")
  end


  def show
    @places = Place.where(area: params[:area])
    @placeinfo = @places.find_by(service: "食べログ")
    @Shops = Shop.where(area: params[:area])
    @tabelogshops = Shop.where(area: params[:area]).where(service: "食べログ")
    @ikkyushops = Shop.where(area: params[:area]).where(service: "一休")
    @rettyshops = Shop.where(area: params[:area]).where(service: "Retty")
    # @clickcnt = Clickcnt.find_by()
  end

  def clickcntdb
    @clickcntdb = Place.clickcnt(params[:area], service, shopname)
  end


  def search
    @allPlaces = Place.all
    @tabelogs = Place.where(service: "食べログ")
    @ikkyus = Place.where(service: "一休")

    if params[:search]
      @places = Place.search(params[:search])
      @placeinfo = @places.find_by(service: "食べログ")
      @tabelogPlaces = Place.where(service: "食べログ")
      @tabelogshops = Shop.where(area: params[:search]).where(service: "食べログ")
      @ikkyushops = Shop.where(area: params[:search]).where(service: "一休")
      @rettyshops = Shop.where(area: params[:search]).where(service: "Retty")
    else
      @places = Place.all
      # @Shops = Shop.all
    end
  end

  def search_exe
    @places = Place.search(params[:search])
    @Shops = Shop.where(area: params[:search])
    @tabelogPlaces = Place.where(service: "食べログ")
    @placeinfo = @places.find_by(service: "食べログ")
    @tabelogshops = Shop.where(area: params[:search]).where(service: "食べログ")
    @ikkyushops = Shop.where(area: params[:search]).where(service: "一休")
    @rettyshops = Shop.where(area: params[:search]).where(service: "Retty")
  end


end
