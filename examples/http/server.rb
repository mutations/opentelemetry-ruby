#!/usr/bin/env ruby
# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
# Require otel-ruby
require 'opentelemetry'
require 'opentelemetry/sdk'

SDK = OpenTelemetry::SDK
OpenTelemetry.tracer_factory = SDK::Trace::TracerFactory.new

# Define exporter that outputs span data to the console
class ConsoleExporter
  include SDK::Trace::Export

  def export(spans)
    Array(spans).each { |s| puts s.inspect }

    SUCCESS
  end
end

class App < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    # Configure tracer
    exporter = ConsoleExporter.new
    processor = SDK::Trace::Export::SimpleSpanProcessor.new(exporter)
    tracer = OpenTelemetry.tracer_factory.tracer('http.server', 'semver:1.0')
    tracer.add_span_processor(processor)

    set :tracer, tracer
  end

  get '/hello' do
    # TODO: extract context, attrs
    settings.tracer.in_span('http.server.get') do |span|
      span.set_attribute('http.server.url', request.path)
      span.set_attribute('http.server.method', request.request_method)
      span.add_event(name: 'handle http.server.get')
    end

    'Hello World!'
  end

  run! if app_file == $0
end
