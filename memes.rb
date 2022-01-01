require_relative 'reddit_pics'

class Meme < RedditPictures
    def initialize
        super 
        @meme_subreddits = ["memes", "Memes_Of_The_Dank", "MemeEconomy", "dankmemes"]
    end

    def get_memes 
        if @image_urls.length <= 1
            get_new_meme_urls 
        end 
        url = @image_urls[0]
        @image_urls.shift 
    end

    private

    def get_new_meme_urls 
        subreddit_index = @count % (@meme_subreddits.length - 1)
        meme_subreddit = @meme_subreddits[subreddit_index]
        results = REDDIT_USER.browse("#{meme_subreddit}/new")
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