require_relative 'reddit_pics'

class Cat < RedditPictures
    def initialize
        super 
        @cat_subreddits = ["cat", "catpics", "cats", "Catswithjobs"]
    end

    def get_cat_image
        if @image_urls.length <= 1
            get_new_cat_urls
        end 

        url = @image_urls[0]
        @image_urls.shift 
    end

    private 

    def get_new_cat_urls 
        subreddit_index = @count % (@cat_subreddits.length - 1)
        cat_subreddit = @cat_subreddits[subreddit_index]
        results = REDDIT_USER.browse("#{cat_subreddit}/new")
        
        results.each do |result|
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