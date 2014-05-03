
require "./figures"
require "./setup"

require 'open-uri'

link = /(http\:\/\/t\.co\/[a-zA-Z0-9]{10})/

tweets = T.user_timeline "CocksDaily", count: 200

media = tweets.map(&:media).flatten.select do |media|
  media.attrs[:type] == "photo"
end.map(&:media_url).map(&:to_s).uniq

year = rand(400) + 1600

figure = FIGURES.sample

T.update_with_media("#{figure} #{year}", open(media.sample), :possibly_sensitive => true)
