class OpenDataAPIRequest
  attr_reader :request, :api_key

  @@api_key = ''
  @@uri_base = ''
  @@http_base = ''

  def initialize(http, uri, api_key)
    @http = http
    @uri = uri
    @api_key = api_key
    @request = self.generate_request_for_api(uri, api_key)
  end

  def self.api_key()
    @@api_key
  end

  def self.set_api_key(api_key)
    @@api_key = api_key
  end

  def self.uri_base()
    @@uri_base
  end

  def self.set_uri_base(uri_base)
    @@uri_base = uri_base
  end

  def self.http_base()
    @@http_base
  end

  def self.set_http_base(http_base)
    @@http_base = http_base
  end

  def generate_request_for_api(uri, api_key)
    # puts "Generating Request for URI: #{uri.to_s}\nURI Host/Port: #{uri.host}, #{uri.port}"
    request = Net::HTTP::Get.new(uri)

    request.initialize_http_header({
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "apikey #{api_key}",
      "User-Agent" => "ruby/net::http"
    })
    # puts "Generated Request with Headers: #{request.to_hash.inspect}"
    request
  end

  # Fetch specific request
  def fetch(http_session, request, limit = 10)
    raise "Too many HTTP redirects" if limit == 0
    response = http_session.request(request) # Net::HTTPResponse object
    
    case response
    when Net::HTTPSuccess then
      if response['content-type'] =~ /json/i
        # puts """Response:\n\t
        # Code: #{response.code}\n\t
        # Message: #{response.message}\n\t
        # Class: #{response.class.name}\n\t
        # Headers: \n #{JSON.pretty_generate(response.to_hash)}
        # Body: \n #{JSON.pretty_generate(JSON.parse(response.body))}
        # """ 
        # puts "Response code #{response.code} for request to: #{request.uri}"
        response
      else
        raise Exception.new("Only JSON response supported")
      end
    when Net::HTTPRedirection then
      location = response['location']
      # puts Net::HTTP.get(URI.parse(location))
      warn "Redirected to #{location}"
      request = Net::HTTP::Get.new(location)
      self.fetch(http_session, request, limit - 1)
    else
      raise Exception.new("Unsupported HTTP Response #{response.inspect}")
    end
  end
end