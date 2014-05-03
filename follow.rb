require "./setup"

ids = T.follower_ids("CocksDaily").take(5000)

ids.sample(5).each do |id|
  T.follow(id)
end
