require 'discordrb'
require 'open-uri'
require 'nokogiri'
require 'ruby_reddit_api'

class RedditPictures 
    REDDIT_USER = Reddit::Api.new 
    attr_reader :permalinks_empty

    def initialize
        @image_urls = []
        @permalinks = []
        @count = 0
        @permalinks_empty = true
    end

    def get_url_from_permalink
        change_permalink_to_url
    end

    private 

     def change_permalink_to_url
        permalinks_left = []
        @permalinks.each do |link|
            url_extracted = false 
            url = "https://www.reddit.com#{link}"

            begin   
                uri = URI.parse(url)
            rescue 
                next 
            end

            html = URI.open(uri)
            response = Nokogiri::HTML(html)
            images = response.css('img')
            images.each do |image|
                image_source = image[:src]
                if image_source.include?('jpg') && !(image_source.include?('styles'))
                    @image_urls << image_source
                    url_extracted = true
                end
            end 
            if !url_extracted
                permalinks_left << link 
            end
        end
        @permalinks = permalinks_left
        check_permalinks_empty
    end

    def check_permalinks_empty
        if @permalinks.empty?
            @permalinks_empty = true 
        else  
            @permalinks_empty = false
        end
    end

end

