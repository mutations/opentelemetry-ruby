require 'faraday'

# Require otel-ruby
require 'opentelemetry'
require 'opentelemetry/sdk'

SDK = OpenTelemetry::SDK

# Define exporter that outputs span data to the console
class ConsoleExporter
  include SDK::Trace::Export

  def export(spans)
    Array(spans).each { |s| puts s.inspect }

    SUCCESS
  end
end

# Configure tracer
tracer = SDK::Trace::Tracer.new
exporter = ConsoleExporter.new
processor = SDK::Trace::Export::SimpleSampledSpanProcessor.new(exporter)
tracer.add_span_processor(processor)
OpenTelemetry.tracer = tracer

class Middleware < Faraday::Middleware
  attr_reader :app

  def initialize(app, options = {})
    super(app)
    # TODO: service name
  end

  def call(env)
    OpenTelemetry.tracer.in_span('faraday.request', kind: 'http') do |span|
      # TODO: resource?
      span.set_attribute('service', 'faraday')
      span.set_attribute('http.url', env[:url].path)
      span.set_attribute('http.method', env[:method].to_s.upcase)
      span.set_attribute('out.host', env[:url].host)
      span.set_attribute('out.port', env[:url].port)

      # TODO: propagate

      app.call(env).on_complete do |resp|
        status = env[:status]
        span.set_attribute('http.status_code', status)

        if (500...600).cover?(status)
          span.set_attribute('error.type', "Error #{status}")
          span.set_attribute('error.msg', env[:body])
        end
      end
    end
  end
end

Faraday::Middleware.register_middleware(open_telemetry: Middleware)

connection = Faraday.new('http://example_server:4567') do |builder|
  builder.use :open_telemetry
  builder.adapter Faraday.default_adapter
end

connection.get('/')
connection.get('/foo')
connection.get('/nope')
connection.get('/error')
