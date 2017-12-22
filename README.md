# OpenData API

[![Gem Version](https://badge.fury.io/rb/opendata-api.svg)](https://badge.fury.io/rb/opendata-api)

* Ruby Gem wrapper for [Transport for NSW Open Data APIs](https://opendata.transport.nsw.gov.au) that opens a HTTP(S) session for multiple configured requests. Currently supported APIs:
  * Traffic Volume Counts API
  * Trip Planner API

## Installation

* Install Gem
  ```bash
  $ gem install opendata-api
  $ bundle install
  ```

* Follow [User Guide of OpenData API](https://opendata.transport.nsw.gov.au/user-guide) to:
    * Register with OpenData API
    * Create App
    * Select APIs Supported by the Gem
    * Obtain associated API Keys
    * Add API Keys to .env file (i.e. `OPENDATA_API_KEY=<INSERT_API_KEY>`)
    * Access the API Key in Ruby app with `ENV['OPENDATA_API_KEY']`

* Usage in Ruby project or IRB
  ```ruby
  require 'opendata-api'
  require 'json'
  require 'dotenv'
  API_KEY = ENV['OPENDATA_API_KEY']
  OpenDataAPI.init(API_KEY)
  args = [
    {
      api_name: 'traffic_volume_counts',
      format: 'geojson',
      table: 'road_traffic_counts_station_reference',
      limit: '50'
    },
    {
      api_name: 'trip_planner',
      format: 'rapidJSON',
      coord_lat: '-33.8688',
      coord_long: '151.2093',
      coord_radius: '1000'
    }
  ]
  response = OpenDataAPI.run(args)
  puts JSON.pretty_generate(JSON.parse(response[:traffic_volume_counts]))
  puts JSON.pretty_generate(JSON.parse(response[:trip_planner]))
  ```

## Contributors

Contributions are welcome. Particularly updating the configuration to support other OpenData APIs.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
