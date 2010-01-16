module Names
require 'array'

@@NAMES = []

  File.open(RAILS_ROOT + '/lib/names.txt').each do |line|
    line.split(" ").each do |name|
      @@NAMES << name
    end
  end
  
def name_generate
 @@NAMES.random
end

  # require "xmlrpc/client"
  # 
  # def name_generate(min_char=5,max_char=10)
  #   server = XMLRPC::Client.new( "www.hamete.org", "/yafnag/rpc")
  #   server.call("names", min_char, max_char, 1)    
  # end
end


