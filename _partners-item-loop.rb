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
url = 'http://www.website.com/contact/index/?page=contact'
page = agent.get(url)

# opens a new csv file and shovels column titles into the first row
CSV.open("partners.csv", "w+") do |csv|
  csv << ["Title", "URL"]
end

# the while loop runs as long as the statement evaluates to true
# searches the page for each movie link
page.search('#partners li a').each do |items|

  ## Pagination variables
  item_title = items.text
  item_url = items.attr('href')

  item = [item_title, item_url]

  items_array = []
  items_array << item

  # appends review information onto the csv we already created
  CSV.open("partners.csv", "a+") do |csv|
    items_array.each do |review|
      csv << review
    end
  end

  # output to terminal
  puts "#{item_title} — saved"
  puts # extra line for spacing

end
