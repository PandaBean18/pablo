require_relative "reddit_pics"

class Dog < RedditPictures
    def initialize
        super
        @dog_subreddits = ["dogpictures", "DOG", "lookatmydog", "goldenretrievers", "germanshepherds"]
    end

    def get_dog_image
        if @image_urls.length <= 1
            get_new_dog_urls
        end 
        
        hash = @image_urls[0]
        @image_urls.shift
        return hash
    end


    private 

    def get_new_dog_urls 
        subreddit_index = @count % (@dog_subreddits.length - 1)
        dog_subreddit = @dog_subreddits[subreddit_index]
        results = REDDIT_USER.browse("#{dog_subreddit}/new")
        results.each do |result|
            #hash = Hash.new()
            if result.url.end_with?("jpg")
                @image_urls << result.url 
            else 
                @permalinks << result.permalink
                @permalinks_empty = false
            end
        end
        @count += 1
    end
end