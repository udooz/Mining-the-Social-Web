require 'nokogiri'
require 'open-uri'

#try http://ajaxian.com
# try https://twitter.com/<your-twitter-name>
url = ARGV[0]

XFN_TAGS = ['colleague',
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
    'friend']

doc = Nokogiri::HTML(open(url))
doc.search('a').each do | a |
  rel_v = a['rel']
  if rel_v && !rel_v.empty?
    tags = rel_v.split
    if (tags & XFN_TAGS).length > 0
      print "#{a.content} #{a['href']} #{tags}\n" 
    end  
  end
end