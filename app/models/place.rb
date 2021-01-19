
require "geocoder"

class Place < ApplicationRecord

  geocoded_by :address
  after_validation :geocode

  def self.search(search)
    if search
      Place.where(['area LIKE ?', "%#{search}%"])
    else
      Place.all
    end
  end


  # 食べログの「ランキングページ」から情報取得
  def self.tabelogScraping(area, service, link)
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))
    @tabelogContents = @Doc.xpath("//div[@class='list-rst__wrap js-open-new-window']") # 各店舗詳細を取得
    @tabelogContents.each do |content|
      @tabelogTitle = content.xpath(".//a[@class='list-rst__rst-name-target cpy-rst-name js-ranking-num']")
      @tabeloghref = @tabelogTitle.attribute("href")
      charset = nil
      # 各店舗の詳細ページへ遷移し、スクレイピング
      html = open(@tabeloghref) do |page|
        charset = page.charset
        page.read
      end
      @tabelogDoc = Nokogiri::HTML(open(@tabeloghref))
      @tabelogAddress = @tabelogDoc.xpath('.//p[@class="rstinfo-table__address"]').text
      @tabelogImg = @tabelogDoc.css("img.p-main-photos__slider-image").attribute("src")
      @tabelogCloseDate = @tabelogDoc.xpath('.//dd[@id="short-comment"]').text.gsub(' ', '').gsub(/[\r\n]/,"")
      @tabelogShopTime = @tabelogDoc.xpath('.//*[@id="rst-data-head"]/table[1]/tbody/tr[8]/td/p[2]').text.gsub('&lt;', '<').gsub('&gt;', '>')
      if not @tabelogImg
        @tabelogImg = @tabelogDoc.css("a.js-imagebox-trigger img").attribute('src')
      end
      @tabelogJenre = @tabelogDoc.at_css('#rst-data-head > table:nth-child(2) > tbody > tr:nth-child(3) > td > span > text()')
      @Shops = Shop.new(name: @tabelogTitle.inner_text, url: @tabeloghref, area: area, service: service, img: @tabelogImg, jenre: @tabelogJenre, address: @tabelogAddress, week:@tabelogCloseDate ,time:@tabelogShopTime)
      @Shops.save
      @clickcnt = Clickcnt.new(
        click: 0,
        area: area,
        service: service,
        shop: @tabelogTitle.inner_text
      )
      @clickcnt.save
    end
  end


  # 一休の「ランキングページ」から情報取得
  def self.ikkyuScraping(area, service, link)
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))
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
      # @ikkyuAddress
      @ikkyuImg = content.css("img").attr('src')
      @ikkyuImg = 'https://restaurant.img-ikyu.com' + @ikkyuImg
      # @ikkyuImg = @ikkyuDoc.search("._3hz4-Nr").map{ |n| n['style'][/url\((.+)\)/, 1] }
      @ikkyuDetail = content.xpath(".//div[@class='retaurantArea_s9Crj']").text.gsub(' ', '').gsub(/[\r\n]/,"")
      @ikkyuStation = @ikkyuDetail.split(/／/)[0]
      @ikkyuJenre = @ikkyuDetail.split(/／/)[1]
      @shop = Shop.new(
        name: @ikkyuTitle,
        url: @ikkyuhref,
        area: area,
        service: service,
        img: @ikkyuImg,
        jenre: @ikkyuJenre,
        address: @ikkyuAddress
      )
      @shop.save
      @clickcnt = Clickcnt.new(
        click: 0,
        area: area,
        service: service,
        shop: @ikkyuTitle
      )
      @clickcnt.save
    end
  end


  # Rettyの「ランキングページ」から情報取得
  def self.rettyScraping(area, service, link)
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))
    @rettyContents = @Doc.xpath("//div[@class='restaurant']")
    @rettyContents.each do |content|
      @rettyhref = content.xpath(".//a[@class='restaurant__block-link']").attribute("href")
      @rettyTitle = content.xpath(".//h3[@class='restaurant__name']").text.gsub(' ', '').gsub(/[\r\n]/,"")
      # @rettyImg = content.css("img").attr('src')
      @rettyImg = ""
      @rettyJenre = content.xpath(".//dd[@class='information-list__description']").text.split('）')[1].gsub(/[\r\n]/,"")
      @Shops = Shop.new(name: @rettyTitle, url: @rettyhref, area: area, service: service, img: @rettyImg, jenre: @rettyJenre)
      @Shops.save
      @clickcnt = Clickcnt.new(
        click: 0,
        area: area,
        service: service,
        shop: @rettyTitle
      )
      @clickcnt.save
    end
  end

  def self.clickcnt(area, service, shopname)
      @clickcnt = Clickcnt.where(area: area).where(service: service).find_by(shop:shopname).click
      @click = @clickcnt.click + 1
      @clickcnt.update(click: @click)
  end

end
