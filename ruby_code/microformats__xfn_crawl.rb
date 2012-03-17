require 'nokogiri'
require 'open-uri'
require 'rgl/adjacency'
require 'rgl/implicit'
require 'rgl/dot'

ROOT_URL = ARGV[0] #url

if ARGV[1] #depth
  MAX_DEPTH = ARGV[1].to_i 
else
  MAX_DEPTH = 1
end
XFN_TAGS = [
    'colleague',
    'sweetheart',
    'parent',
    'co-resident',
    'co-worker',
    'muse',
    'neighbor',
    'sibling',
    'kin',
    'child',
    'date',
    'spouse',
    'me',
    'acquaintance',
    'met',
    'crush',
    'contact',
    'friend',
    ]
OUT = 'xfn_graph.dot'

depth = 0

g = RGL::DirectedAdjacencyGraph.new

next_queue = [ROOT_URL]

while depth < MAX_DEPTH
  depth += 1
  queue, next_queue = next_queue, []
  
  queue.each do |item|
    begin
      doc = Nokogiri::HTML(open(item))
    rescue
      p "Unable to open the URL #{item}"
      next
    end
    anchor_tags = doc.search('a')
    
    g.add_vertex(item) if !g.has_vertex?(item)
    
    anchor_tags.each do |a|
      if a['rel'] 
        rel = a['rel']
        tags = rel.split
        if (tags & XFN_TAGS).length > 0
          friend_url = a['href']        
          g.add_edge(item, friend_url) 
          
          next_queue.push(friend_url)
        end
      end      
    end
  end
end

g.write_to_graphic_file(fmt='png', dotfile=OUT)
