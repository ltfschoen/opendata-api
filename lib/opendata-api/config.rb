module OpenDataAPI
  module Constants
    # Transport for NSW (TfNSW) Open Data API
    BASE_URL = 'https://api.transport.nsw.gov.au'
    READ_TIMEOUT = 500
    REQUEST_LIMIT = 3

    # Traffic Volume Counts API
    module TrafficVolumeCountsAPI
      BASE_URL = 'https://api.transport.nsw.gov.au/v1'
      API_ENDPOINT = '/roads/spatial'
      PARAM_FORMAT = 'geojson'
      def self.query_string_params(format, table, limit)
        "?format=#{format}&q=select%20*%20from%20#{table}%20limit%20#{limit}%20"
      end
    end

    # Trip Planner API
    module TripPlannerAPI
      BASE_URL = 'https://api.np.transport.nsw.gov.au/v1'
      API_ENDPOINT = '/tp/coord'
      PARAM_FORMAT = 'rapidJSON'
      def self.query_string_params(format, coord_lat = '-33.8688', coord_long = '151.2093', coord_radius = '1000')
        "?outputFormat=#{format}&coord=#{coord_long}%3A#{coord_lat}%3AEPSG%3A4326&inclFilter=1&" +
        "type_1=GIS_POINT&radius_1=#{coord_radius}&PoisOnMapMacro=true&version=10.2.1.42"
      end  
    end
  end
end
