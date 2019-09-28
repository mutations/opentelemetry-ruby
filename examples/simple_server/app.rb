# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

# docker-compose run --service-ports --workdir /app/examples/simple_server examples ruby app.rb -o 0.0.0.0
require 'sinatra'

# Require otel-ruby
require 'opentelemetry'
require 'opentelemetry/sdk'

get '/' do
  'Hello World!'
end
