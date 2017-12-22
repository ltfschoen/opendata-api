Gem::Specification.new do |s|
  s.name        = 'opendata-api'
  s.version     = '0.1.0'
  s.date        = '2017-12-22'
  s.summary     = "OpenData API"
  s.description = "Wrapper for Transport for New South Wales (TfNSW) Open Data APIs"
  s.authors     = ["Luke Schoen"]
  s.email       = 'ltfschoen@gmail.com'
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0")
  s.required_rubygems_version = Gem::Requirement.new(">= 2.2.0")
  # Self-signing Certificates http://guides.rubygems.org/security/
  s.cert_chain  = ['certs/ltfschoen.pem']
  s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/
  # http://guides.rubygems.org/specification-reference/#files
  s.files       = ['lib/opendata-api.rb']
  s.files       += Dir['lib/*.rb']
  s.files       += Dir['lib/opendata-api/**/*']
  # s.executables << 'opendata-api'
  s.homepage    = 'https://github.com/ltfschoen/opendata-api'
  s.license     = 'MIT'
end