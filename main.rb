require 'discordrb'
require 'discordrb/webhooks'
require_relative 'reddit_pics'
require_relative 'dogs'
require_relative 'cats'
require_relative 'memes'


pablo = Discordrb::Commands::CommandBot.new(token: "OTI0MzE2MTUzODk4MjA1MjM2.YccygA.ZuY4NkuCIRwbmAYpkIT-HTLPOAk", prefix: "%")
WEBHOOK_URL = 'https://discord.com/api/webhooks/424070213278105610/yByxDncRvHi02mhKQheviQI2erKkfRRwFcEp0MMBfib1ds6ZHN13xhPZNS2-fJo_ApSw'.freeze
client = client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)
DOG = Dog.new 
CAT = Cat.new 
MEME = Meme.new 


pablo.message do |event| 
    if event.text.start_with?("<@!924316153898205236>")
        event.respond("My prefix is #{pablo.prefix}")
    end

    if !(DOG.permalinks_empty)
        DOG.get_url_from_permalink
    end 

    if !(CAT.permalinks_empty)
        CAT.get_url_from_permalink
    end 

    if !(MEME.permalinks_empty)
        MEME.get_url_from_permalink
    end 

end

pablo.command(:help) do |event|
    text = ""
    pablo.commands.each do |command|
        text += "#{command.name}\n"
    end
    return text
end

pablo.command(:hug, min_args: 0, max_args: 1) do |event, user|
    if user 
        return "<@#{event.user.id}> hugs #{user} :people_hugging:"
    else  
        return "<@#{event.user.id}> has had a hard day and needs a hug :sneezing_face:"
    end 
end

pablo.command(:slap, min_args: 0, max_args: 1) do |event, user|
    if user 
        return "<@#{event.user.id}> slaps #{user} with fish"
    else  
        return "<@#{event.user.id}> wants a slap on their ass. Kinky."
    end 
end


pablo.command(:userId, min_args: 1, max_args: 1) do |event, user|
    return get_user_id(user)
end

pablo.command(:s) do |event|
    return event.server.id 
end

pablo.command(:dog) do |event|
    dog_url = DOG.get_dog_image
    event.channel.send_embed() do |embed|
        embed.title = "Image from r/dogpictures"
        embed.colour = "ff0000"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: dog_url)
    end
end

pablo.command(:cat) do |event|
    cat_url = CAT.get_cat_image
    event.channel.send_embed do |embed|
        embed.title = "Image from r/catpics"
        embed.colour = "ff0000"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: cat_url)
    end
end

pablo.command(:meme) do |event|
    meme_url = MEME.get_memes 
    event.channel.send_embed do |embed|
        embed.title = "Image from r/memes"
        embed.colour = "ff0000"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: meme_url)
    end 
end

pablo.command(:boobs) do |event|
    event.channel.send_embed do |embed|
        embed.title = "Stop being horny"
        embed.color = "9c5f3e"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: "https://cdn.discordapp.com/attachments/844189298030673940/926063961886031902/bonk2.png")
    end
end

def get_user_id(user)
    pattern = /\<\@\!*(\d+)/
    id =  user.match(pattern).captures
    return id[0].to_i
end

pablo.run