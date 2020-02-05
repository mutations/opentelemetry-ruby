# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'rubygems'
require 'bundler/setup'

Bundler.require

require_relative 'example_api'

# Example of running config.ru via rackup:
# bash-5.0$ bundle exec rackup --host 0.0.0.0 --port 4567 --debug &
#
# Then,
# bash-5.0$ ruby -r rest_client -e "RestClient.get('localhost:4567/')"
#
# Expected output:
# Span data will be written to console.
#

OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Adapters::Rack'
end

use OpenTelemetry::Adapters::Rack::Middlewares::TracerMiddleware
run ExampleAPI