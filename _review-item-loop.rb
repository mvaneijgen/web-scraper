# nokogiri requires open-uri
require 'nokogiri'
require 'open-uri'
# csv will be used to export data
require 'csv'
require 'mechanize'
# pp is useful to display mechanize objects
require 'pp'

# Collect all items
# ===============================================
agent = Mechanize.new

# creates a Mechanize page using siteurl
url = 'http://www.website.com/page/index/?page=mission-statement'
page = agent.get(url)

# opens a new csv file and shovels column titles into the first row
CSV.open("reviews.csv", "w+") do |csv|
  csv << ["Title", "Content", "Werk koppeling", "URL"]
end

# the while loop runs as long as the statement evaluates to true
# searches the page for each movie link
page.search('nav.blok > ul > li:nth-child(3) ul li a').each do |items|

  ## Pagination variables
  item_url = items.attr('href')
  ## Go to the page
  item_page = agent.get("#{item_url}")

  ## Get content from inner item_page

  item_page.search('#press li').each do |reviews|
    item_title = reviews.css('p span').text
    item_content = reviews.css('p').text
    item_koppeling = item_page.css('.eight.columns.blok h2').text
    # item_url = reviews.search('p a').attr('href')
    # if image_link = doc.at_css(".entry-content img")
    if reviews.search('p a').empty? #=> true
      item_url = reviews.search('a').attr('href')
    else
      item_url = ''
    end

    item = [item_title, item_content, item_koppeling, item_url]
    items_array = []

    items_array << item

    # appends review information onto the csv we already created
    CSV.open("reviews.csv", "a+") do |csv|
      items_array.each do |review|
        csv << review
      end
    end

  end

  # output to terminal
  puts "saved"
  puts # extra line for spacing

end
