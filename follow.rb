require "./setup"

ids = T.follower_ids("CocksDaily").take(5000)

ids.sample(10).each do |id|
  begin
    T.follow(id)
  rescue Exception => e
    puts e.message
  end
end
