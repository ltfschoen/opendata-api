require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'openssl'

require_relative './opendata-api/config'
require_relative './opendata-api/request'

module OpenDataAPI
  def self.init(api_key)
    raise "OpenData API Key required" if api_key.empty?

    uri_base = URI.parse(OpenDataAPI::Constants::BASE_URL)
    http_base = Net::HTTP.new(uri_base.host, uri_base.port)

    # Store API Key as class variable
    OpenDataAPIRequest.set_api_key(api_key)

    # Store URI and HTTP base as class variables
    OpenDataAPIRequest.set_uri_base(uri_base)
    OpenDataAPIRequest.set_http_base(http_base)
  end

  def self.run(args)
    api_requests = []
    args.each do |arg|
      case arg[:api_name]
      when 'traffic_volume_counts'
        # Request for Traffic Volume Counts API
        uri_traffic_volume_counts_api = URI.parse(
          OpenDataAPI::Constants::TrafficVolumeCountsAPI::BASE_URL + 
          OpenDataAPI::Constants::TrafficVolumeCountsAPI::API_ENDPOINT + 
          OpenDataAPI::Constants::TrafficVolumeCountsAPI.query_string_params(arg[:format], arg[:table], arg[:limit])
        )
        request_for_traffic_volume_counts_api = {
          api_name: arg[:api_name],
          api_instance: OpenDataAPIRequest.new(OpenDataAPIRequest.http_base, uri_traffic_volume_counts_api, OpenDataAPIRequest.api_key)
        }
        api_requests << request_for_traffic_volume_counts_api
      when 'trip_planner'
        # Request for Trip Planner API
        uri_trip_planner_api = URI.parse(
          OpenDataAPI::Constants::TripPlannerAPI::BASE_URL + 
          OpenDataAPI::Constants::TripPlannerAPI::API_ENDPOINT + 
          OpenDataAPI::Constants::TripPlannerAPI.query_string_params(arg[:format], arg[:coord_lat], arg[:coord_long], arg[:coord_radius])
        )
        request_for_trip_planner_api = {
          api_name: arg[:api_name],
          api_instance: OpenDataAPIRequest.new(OpenDataAPIRequest.http_base, uri_trip_planner_api, OpenDataAPIRequest.api_key)
        }
        api_requests << request_for_trip_planner_api
      else
        raise ArgumentError.new("Invalid API Name")
      end
    end

    begin
      # Start HTTP(S) Session to re-use across multiple requests
      Net::HTTP.start(OpenDataAPIRequest.uri_base.hostname, OpenDataAPIRequest.uri_base.port,
        :use_ssl => OpenDataAPIRequest.uri_base.scheme == 'https') do |http_session|
        puts http_session.use_ssl? ? "OpenData API HTTPS Session" : "OpenData API HTTP Session"

        http_session.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http_session.read_timeout = OpenDataAPI::Constants::READ_TIMEOUT

        response = {}
        # Request #1 to each API (i.e. Traffic Volume Counts API, Trip Planner API, etc)
        api_requests.each do |request|
          _res = request[:api_instance].fetch(http_session, request[:api_instance].request, OpenDataAPI::Constants::REQUEST_LIMIT)
          # puts JSON.pretty_generate(JSON.parse(_res.body))
          response[request[:api_name].to_sym] = _res.body
        end
        response
      end
    rescue Exception => e
      raise "Exception opening TCP connection: #{e}"
    end
  end
end
