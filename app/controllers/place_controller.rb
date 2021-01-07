require "open-uri"
require "nokogiri"

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
    @place = Place.new(
      area: params[:area],
      url: params[:url],
      service: params[:service]
    )
    link = params[:url]
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))

    if params[:service] == "食べログ"
      @tabelogContents = @Doc.xpath("//div[@class='list-rst__wrap js-open-new-window']")
      @tabelogContents.each do |content|
        @tabelogTitle = content.xpath(".//a[@class='list-rst__rst-name-target cpy-rst-name js-ranking-num']")
        @tabeloghref = @tabelogTitle.attribute("href")
        charset = nil
        html = open(@tabeloghref) do |page|
          charset = page.charset
          page.read
        end
        @tabelogDoc = Nokogiri::HTML(open(@tabeloghref))
        @tabelogImg = @tabelogDoc.css("img.p-main-photos__slider-image").attribute("src")
        if not @tabelogImg
          @tabelogImg = @tabelogDoc.css("a.js-imagebox-trigger img").attribute('src')
        end
        @tabelogJenre = @tabelogDoc.at_css('#rst-data-head > table:nth-child(2) > tbody > tr:nth-child(3) > td > span > text()')
        @Shops = Shop.new(name: @tabelogTitle.inner_text, url: @tabeloghref, area: params[:area], service: params[:service], img: @tabelogImg, jenre: @tabelogJenre)
        @Shops.save
      end
    elsif params[:service] == '一休'
      @ikkyuContents = @Doc.xpath("//section[@class='restaurantCard_jpBMy']")
      @ikkyuContents.each do |content|
        @ikkyuhref = content.xpath(".//a[@class='cover_3Ae77']").attribute("href")
        @ikkyuhref = 'https://restaurant.ikyu.com' + @ikkyuhref
        @ikkyuTitle = content.xpath(".//h3[@class='restaurantName_2s_sg']").text.gsub(' ', '').gsub(/[\r\n]/,"")
        # charset = nil
        # html = open(@ikkyuhref) do |page|
        #   charset = page.charset
        #   page.read
        # end
        # @ikkyuDoc = Nokogiri::HTML(open(@ikkyuhref))
        # @ikkyuChildContents = @ikkyuDoc.at_css("div.carousel-slide")
        @ikkyuImg = content.xpath(".//img[@class='image_3ZIQh']/@src")
        # @ikkyuImg = @ikkyuDoc.search("._3hz4-Nr").map{ |n| n['style'][/url\((.+)\)/, 1] }
        @ikkyuJenre = content.xpath(".//div[@class='retaurantArea_s9Crj']").text.gsub(' ', '').gsub(/[\r\n]/,"")
        @Shops = Shop.new(name: @ikkyuTitle, url: @ikkyuhref, area: params[:area], service: params[:service], img: @ikkyuImg, jenre: @ikkyuJenre)
        @Shops.save
      end
    end

    if @place.save
      flash[:notice] = "地域登録が完了しました"
      redirect_to("/place/#{@place.area}")
    else
      flash[:notice] = "地域登録が失敗しました"
      render("place/new")
    end
  end


  def edit
    @allPlaces = Place.all
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
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))

    if params[:service] == "食べログ"
      @shops.destroy_all
      @tabelogContents = @Doc.xpath("//div[@class='list-rst__wrap js-open-new-window']")
      @tabelogContents.each do |content|
        @tabelogTitle = content.xpath(".//a[@class='list-rst__rst-name-target cpy-rst-name js-ranking-num']")
        @tabeloghref = @tabelogTitle.attribute("href")
        charset = nil
        html = open(@tabeloghref) do |page|
          charset = page.charset
          page.read
        end
        @tabelogDoc = Nokogiri::HTML(open(@tabeloghref))
        @tabelogImg = @tabelogDoc.css("img.p-main-photos__slider-image").attribute("src")
        if not @tabelogImg
          @tabelogImg = @tabelogDoc.css("a.js-imagebox-trigger img").attribute('src')
        end
        @tabelogJenre = @tabelogDoc.at_css('#rst-data-head > table:nth-child(2) > tbody > tr:nth-child(3) > td > span > text()')
        @shop = Shop.new(name: @tabelogTitle.inner_text, url: @tabeloghref, area: params[:area], service: params[:service], img: @tabelogImg, jenre: @tabelogJenre)
        @shop.save
      end
    elsif params[:service] == '一休'
      @shops.destroy_all
      @ikkyuContents = @Doc.xpath("//section[@class='restaurantCard_jpBMy']")
      @ikkyuContents.each do |content|
        @ikkyuhref = content.xpath(".//a[@class='cover_3Ae77']").attribute("href")
        @ikkyuhref = 'https://restaurant.ikyu.com' + @ikkyuhref
        @ikkyuTitle = content.xpath(".//h3[@class='restaurantName_2s_sg']").text.gsub(' ', '').gsub(/[\r\n]/,"")
        # charset = nil
        # html = open(@ikkyuhref) do |page|
        #   charset = page.charset
        #   page.read
        # end
        # @ikkyuDoc = Nokogiri::HTML(open(@ikkyuhref))
        # @ikkyuChildContents = @ikkyuDoc.at_css("div.carousel-slide")
        @ikkyuImg = content.xpath(".//img[@class='image_3ZIQh']/@src")
        # @ikkyuImg = @ikkyuDoc.search("._3hz4-Nr").map{ |n| n['style'][/url\((.+)\)/, 1] }
        @ikkyuJenre = content.xpath(".//div[@class='retaurantArea_s9Crj']").text.gsub(' ', '').gsub(/[\r\n]/,"")
        @shop = Shop.new(name: @ikkyuTitle, url: @ikkyuhref, area: params[:area], service: params[:service], img: @ikkyuImg, jenre: @ikkyuJenre)
        @shop.save
      end
    end

    flash[:notice] = "地域更新が完了しました"
    redirect_to("/place/edit")
  end


  def show
    @places = Place.where(name: params[:name])
    @Shops = Shop.where(area: params[:area])
    @tabeloghops = Shop.where(area: params[:area]).where(service: "食べログ")
    @ikkyushops = Shop.where(area: params[:area]).where(service: "一休")
  end


  def search
    @allPlaces = Place.all
    @tabelogs = Place.where(service: "食べログ")

    if params[:search]
      @places = Place.search(params[:search])
      @tabeloghops = Shop.where(area: params[:search]).where(service: "食べログ")
      @ikkyushops = Shop.where(area: params[:search]).where(service: "一休")
      # @tabelogContents = Place.tabelogContents(params[:search])
      # @rettyContents = Place.rettyContents(params[:search])
      # @ikkyuContents = Place.ikkyuContents(params[:search])
    else
      @places = Place.all
      # @Shops = Shop.all
    end
  end

  def search_exe
    @places = Place.search(params[:search])
    @Shops = Shop.where(area: params[:search])
    # @services = Place.services(params[:search])
    # @tabelogTitles = Place.tabelogTitles(params[:search])
    # @rettyTitles = Place.rettyTitles(params[:search])
  end


end
