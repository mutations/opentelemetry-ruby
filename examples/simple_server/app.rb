# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

# docker-compose run --service-ports --workdir /app/examples/simple_server examples bundle exec ruby app.rb
require 'sinatra/base'

# Require otel-ruby
require 'opentelemetry'
require 'opentelemetry/sdk'

SDK = OpenTelemetry::SDK
RACK_ENV_REQUEST_SPAN = 'opentelemetry.sinatra_request_span'

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

# Sinatra middleware
class TracerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # TODO: extract distributed context/propagators

    # Make variables available outside of block
    status, headers, response_body = 200, {}, ''

    OpenTelemetry.tracer.in_span('sinatra.request', kind: 'web') do |span|
      span.set_attribute('service', 'sinatra')

      # Store the span on the `env`
      env[RACK_ENV_REQUEST_SPAN] = span

      # Run application stack
      status, headers, response_body = @app.call(env)

      # Add "response" headers as span attributes
      headers.each do |header, value|
        span.set_attribute(
          "http.response.headers.#{header_to_tag(header)}",
          value.to_s
        )
      end
    end

    # Return required values for middleware
    [status, headers, response_body]
  end

  private

  def header_to_tag(name)
    name.to_s.downcase.gsub(/[-\s]/, '_')
  end
end

# Sinatra tracer
module Tracer
  # Keep track of the route name
  def route(verb, action, *)
    condition do
      @tracing_route = "#{request.script_name}#{action}"
    end

    super
  end

  # Sinatra hook after extension is registered
  def self.registered(app)
    # Create tracing `render` method
    ::Sinatra::Base.module_eval do
      def render(engine, data, *)
        ''.tap do |output|
          OpenTelemetry.tracer.in_span('sinatra.render_template') do |span|
            template_name = data.is_a?(Symbol) ? data : :literal
            span.set_attribute('sinatra.template_name', template_name.to_s)
            output = super
          end
        end
      end
    end

    app.use TracerMiddleware

    app.before do
      span = env[RACK_ENV_REQUEST_SPAN]
      return unless span

      span.set_attribute('http.url', request.path)
      span.set_attribute('http.method', request.request_method)
    end

    app.after do
      span = env[RACK_ENV_REQUEST_SPAN]
      return unless span

      # TODO: resource?
      span.set_attribute('sinatra.route.path', @tracing_route)
      span.set_attribute('http.status_code', response.status)

      if response.server_error?
        e = env['sinatra.error']
        return unless e.respond_to?(:type)

        span.set_attribute('error.type', e.type) unless e.type.empty?
        span.set_attribute('error.msg', e.message) unless e.message.empty?
        span.set_attribute('error.stack', e.backtrace) unless e.backtrace.empty?
      end
    end
  end
end

# Sinatra app
class App < Sinatra::Base
  set :bind, '0.0.0.0'
  register Tracer

  template :index do
    'Hello World!'
  end

  # Uses `render` method
  get '/' do
    erb :index
  end

  get '/foo' do
    'Hello Foo!'
  end

  get '/error' do
    500
  end

  run! if app_file == $0
end
