puts "#{__LINE__} requiring adapters/faraday..."
require 'opentelemetry/adapters/faraday'
puts "#{__LINE__} installing adapters/faraday..."
OpenTelemetry::Adapters::Faraday.install

if defined?(OpenTelemetry::Adapters::Faraday::TRACER_VERSION)
  puts "#{__LINE__} tracer version: #{OpenTelemetry::Adapters::Faraday::TRACER_VERSION.inspect}"
else
  puts "#{__LINE__} tracer version: #{OpenTelemetry::Adapters::Faraday.send(:tracer_version).inspect}"
end

def do_require
  puts "#{__LINE__}  requiring faraday..."
  require 'faraday'
end
do_require

if defined?(OpenTelemetry::Adapters::Faraday::TRACER_VERSION)
  puts "#{__LINE__} tracer version: #{OpenTelemetry::Adapters::Faraday::TRACER_VERSION.inspect}"
else
  puts "#{__LINE__} tracer version: #{OpenTelemetry::Adapters::Faraday.send(:tracer_version).inspect}"
end

puts "#{__LINE__} spec version: #{Gem.loaded_specs['faraday']&.version.to_s}"
