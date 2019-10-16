#!/usr/bin/env ruby
# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0
require 'rubygems'
require 'bundler/setup'
require 'faraday'
# Require otel-ruby
require 'opentelemetry'
require 'opentelemetry/sdk'

# Allow setting the host from the ENV
host = ENV.fetch('HTTP_EXAMPLE_HOST', '0.0.0.0')

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

# Configure tracer
exporter = ConsoleExporter.new
processor = SDK::Trace::Export::SimpleSpanProcessor.new(exporter)
tracer = OpenTelemetry.tracer_factory.tracer('http.client', 'semver:1.0')
tracer.add_span_processor(processor)

connection = Faraday.new("http://#{host}:4567")
url = '/hello'

tracer.in_span('http.client.get') do |span|
  span.set_attribute('http.client.url', url)
  span.set_attribute('http.client.method', 'GET')
  span.add_event(name: 'request http.client.get')

  connection.get(url)
end
