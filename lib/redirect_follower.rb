require 'net/http'

class RedirectFollower
    
  def self.resolve( url )
    response = Net::HTTP.get_response( URI.parse(url) )
    if response && response.kind_of?(Net::HTTPRedirection)      
      if response['location'].nil?
        return response.body.match(/<a href=\"([^>]+)\">/i)[1]
      else
        return response['location']
      end
    end
    return url
  end

end