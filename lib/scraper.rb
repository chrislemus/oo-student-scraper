require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html) 
    student_cards = doc.css('.student-card').map {|student|
      {
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
    }
    student_cards
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile = Nokogiri::HTML(html) 
    last_name = profile.css('.profile-name').text.downcase.split(" ")[1]
    profile_data = {}
    profile.css(".social-icon-container a").map{ |social| 
      url = social.attribute("href").value
      site_name = url[/\w+(?=\.com)/]
      site_name = 'blog' if site_name.include?(last_name)
      profile_data[site_name.to_sym] = url
    }
    profile_data[:profile_quote] = profile.css('.profile-quote').text
    profile_data[:bio] = profile.css('.bio-content .description-holder p').text
    profile_data
    # binding.pry
  end

end

