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
url = 'http://www.website.com/text/item/?page=teksten'
page = agent.get(url)

# opens a new csv file and shovels column titles into the first row
CSV.open("teksten.csv", "w+") do |csv|
  csv << ["Title", "Author", "Content", "Images", "URL"]
end

# the while loop runs as long as the statement evaluates to true
# searches the page for each movie link
page.search('#plays li a').each do |items|

  ## Pagination variables
  item_url = items.attr('href')
  item_author = items.text

  ## Go to the page
  item_page = agent.get("#{item_url}")

  ## Get content from inner item_page
  item_title = item_page.css('.eight.columns.blok h2').text
  item_content = item_page.css('.maintext')

  arrayImages = []
  loopImages = item_page.search('.four.columns.blok.center img').each do |images|
    arrayImages << images
  end

  item_images = arrayImages

  item = [item_title, item_author, item_content, item_images, item_url]
  items_array = []

  items_array << item


  # appends review information onto the csv we already created
  CSV.open("teksten.csv", "a+") do |csv|
    items_array.each do |review|
      csv << review
    end
  end

  # output to terminal
  puts "#{item_title} — saved"
  puts # extra line for spacing

end
