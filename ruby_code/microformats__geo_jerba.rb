#since http://local.mapquest.com/franklin-tn no longer has geo microformats
#instead I've found http://jerba.be/fr/annuaire/uib-djerba-s32.html which is based on vHard geo

require 'nokogiri'
require 'open-uri'

url = ARGV[0]

begin
  page = Nokogiri::HTML(open(url))
rescue
  p "Unable to open #{url}"
  exit
end

geo_tag = page.css('div.geo')[0]

if geo_tag
  geos = geo_tag.search('span')
  print "Location is #{geos[0].content},#{geos[1].content}"
else
  print "No location found"
end
