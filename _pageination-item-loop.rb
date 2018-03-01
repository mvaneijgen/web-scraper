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
url = 'http://www.website.com/news/archive/?page=nieuwsarchief'
page = agent.get(url)

# opens a new csv file and shovels column titles into the first row
CSV.open("niews.csv", "w+") do |csv|
  csv << ["Title", "Date", "Content", "Image", "URL"]
end

# intializes another_page and page_num variables
another_page = true
page_num = 1

# the while loop runs as long as the statement evaluates to true
while another_page == true
  # searches the page for each movie link
  page.search('.maintext ul li').each do |items|
    ## Pagination variables
    item_title = items.css('a').text
    item_url = items.css('a').attr('href')
    item_date = items.text

    ## Go to the page
    item_page = agent.get("#{item_url}")

    ## Get content from inner item_page
    item_content = item_page.css('.maintext')
    item_image = item_page.css('.six.columns.blok img.responsive')

    item = [item_title, item_date, item_content, item_image, item_url]
    items_array = []

    items_array << item


    # appends review information onto the csv we already created
    CSV.open("niews.csv", "a+") do |csv|
      items_array.each do |review|
        csv << review
      end
    end

    # output to terminal
    puts "#{item_title} — saved"
    puts # extra line for spacing

  end

  # checks if there is a disabled right button class somewhere on the page
  disabled_right_button = page.search('.pagination span.next.disabled')

  if disabled_right_button.any?
    another_page = false # stops the loop from running again
  else
    page = agent.get("http://www.website.com/news/archive/?num=#{page_num+1}&page=nieuwsarchief")
  end

  page_num += 1
end
