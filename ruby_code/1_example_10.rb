rt_patterns = /(RT|via)\b\W*@(\w+)/i

example_tweets = ["RT @udooz Sheik is joing Azure moment.  w00t?!",
  "Sheik is joing Azure moment. w00t?! (via @udooz)",
  "Sheik is joing Azure moment. w00t?!"]

example_tweets.each do |t|
  md = rt_patterns.match(t)
  print(md[2], "\n") if md != nil
end