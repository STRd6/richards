require "./setup"

ids = T.follower_ids("CocksDaily").take(5000)

ids.sample(10).each do |id|
  T.follow(id)
end
