require "./cache"
require "./figures"
require "./setup"

require 'open-uri'

tweets = T.user_timeline "CocksDaily", count: 200

media = tweets.map(&:media).flatten.select do |media|
  media.attrs[:type] == "photo"
end.map(&:media_url).map(&:to_s).uniq


data = get("figures").sample
puts data
figure, born, died = data

begin
  born = Date.parse(born).year

  if died
    died = Date.parse(died).year
  else
    died = born + 50
  end

  start = born + 13

  year = rand(died - start) + start

  year = if year < 0
    "#{-year} BC"
  elsif year == 0
    "1 AD"
  else
    "#{year} AD"
  end
rescue
  year = "#{rand(2014) + 1} AD"
end

message = "#{figure} #{year}"
puts message

T.update_with_media(message, open(media.sample), :possibly_sensitive => true)
