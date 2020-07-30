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
    link_array = profile_page.css(".social-icon-container").children.css("a").map {|element| element.attribute("href").value}
    
    link_array.each do |link|
      if link.include?("twitter")
        scraped_student[:twitter] = link
      elsif link.include?("linkedin")
        scraped_student[:linkedin] = link
      elsif link.include?("github")
        scraped_student[:github] = link
      else 
        scraped_student[:blog] = link
      end
    end
    
    profile_quote = profile_page.css(".profile-quote").text
    scraped_student[:profile_quote] = profile_quote
    profile_bio = profile_page.css(".description-holder p").text
    scraped_student[:bio] = profile_bio
    scraped_student
  
  end
end

