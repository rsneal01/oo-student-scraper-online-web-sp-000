require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_roster = Nokogiri::HTML(open(index_url))
    scraped_students = []
    
    student_roster.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
      scraped_students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.attr("href")
        # how are we supposed to know to use .attr here?
      }
      
    end
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    scraped_student = {}
    profile_page.css("body").each do |attribute|
      scraped_student = {
        :profile_quote => attribute.css("div.profile-quote").text,
        :bio => attribute.css("div.description-holder p").text,
        # :twitter => ,
        # :linkedin => ,
        # :blog => ,
        # :github =>
      }
    end
    scraped_student
  end

end

