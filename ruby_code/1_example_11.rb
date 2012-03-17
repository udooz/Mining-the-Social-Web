require 'rgl/adjacency'
require 'rgl/implicit'
require 'rgl/dot'
require 'twitter'

$g = RGL::DirectedAdjacencyGraph.new

search_results = []

for page in 1..5 do
  search_results.push(Twitter.search('dravid', {:rpp => 100, :page => page, :lang => 'en'}))
end

all_tweets = search_results.flatten

def get_rt_sources(tweet)
  rt_patterns = /(RT|via)\b\W*@(\w+)/i
  match = rt_patterns.match(tweet)
  return match
end

all_tweets.each do |tweet|
  rt_source = get_rt_sources(tweet['text'])
  next if rt_source == nil  
  $g.add_edge(rt_source[2].strip, tweet['from_user']) 
end

$g.write_to_graphic_file(fmt='png', dotfile='dravid')