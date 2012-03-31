require 'tmail'
require 'json'

source_path = ARGV[0]

json_whole_msg = "["

Dir.foreach(source_path) do |file_name|
  file_path = File.join(source_path, file_name)
  if !File.directory?(file_path)
    email = TMail::Mail.load(file_path)
    json_msg = "{"
    
    email.each_header do |k,v|      
      key = k.to_s
      if key.gsub(/x-.+/).count == 0
        json_msg = json_msg + '"' + key + '":"' + v.to_s + '",'
        json_msg.gsub!(/\\/, "/")
      end
    end
    if json_msg.rindex(',')
      body = email.body
      body.gsub!(/[\r\t\n]/, '')
      body.gsub!(/\\/, '/')
      body.gsub!(/"/, "'")
      json_msg = json_msg + '"body":"' + body + '"}'
      json_whole_msg = json_whole_msg + json_msg + ","
    end    
  end
end

json_whole_msg = json_whole_msg.slice(0, json_whole_msg.rindex(',')) + "]"

File.open("out.json", 'w') do |f|
  f.puts json_whole_msg
end