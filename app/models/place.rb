class Place < ApplicationRecord

  def self.search(search)
    if search
      Place.where(['area LIKE ?', "%#{search}%"])
    else
      Place.all
    end
  end


  def self.tabelogScraping(area, service, link)
    charset = nil
    html = open(link) do |page|
      #charsetを自動で読み込み、取得
      charset = page.charset
      #中身を読む
      page.read
    end
    @Doc = Nokogiri::HTML(open(link))
    @tabelogContents = @Doc.xpath("//div[@class='list-rst__wrap js-open-new-window']")
    @tabelogContents.each do |content|
      @tabelogTitle = content.xpath(".//a[@class='list-rst__rst-name-target cpy-rst-name js-ranking-num']")
      @tabeloghref = @tabelogTitle.attribute("href")
      charset = nil
      # 書く詳細ページ内の情報をスクレイピング
      html = open(@tabeloghref) do |page|
        charset = page.charset
        page.read
      end
      @tabelogDoc = Nokogiri::HTML(open(@tabeloghref))
      @tabelogAddress = @tabelogDoc.xpath('.//p[@class="rstinfo-table__address"]').text
      @tabelogImg = @tabelogDoc.css("img.p-main-photos__slider-image").attribute("src")
      if not @tabelogImg
        @tabelogImg = @tabelogDoc.css("a.js-imagebox-trigger img").attribute('src')
      end
      @tabelogJenre = @tabelogDoc.at_css('#rst-data-head > table:nth-child(2) > tbody > tr:nth-child(3) > td > span > text()')
      @Shops = Shop.new(name: @tabelogTitle.inner_text, url: @tabeloghref, area: area, service: service, img: @tabelogImg, jenre: @tabelogJenre, address: @tabelogAddress)
      @Shops.save
    end
  end


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
      @shop = Shop.new(name: @ikkyuTitle, url: @ikkyuhref, area: area, service: service, img: @ikkyuImg, jenre: @ikkyuJenre, address: @ikkyuAddress)
      @shop.save
    end
  end


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
    end
  end

end
