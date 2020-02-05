# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'rubygems'
require 'bundler/setup'

Bundler.require

# run via, e.g.,
# $ docker-compose run --rm ex-adapter-rack-grape
# bash-5.0$ ruby trace_demonstration.rb

OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Adapters::Rack'
end

# setup fake grape application:
require_relative 'example_api'

builder = Rack::Builder.new_from_string(<<-EOS)
  use OpenTelemetry::Adapters::Rack::Middlewares::TracerMiddleware
  run ExampleAPI
EOS

# demonstrate tracing (span output to console):
puts Rack::MockRequest.new(builder).get('/')
