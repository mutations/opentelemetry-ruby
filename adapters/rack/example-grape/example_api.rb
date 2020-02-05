# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'grape'

require 'opentelemetry/adapters/rack/middlewares/tracer_middleware'

class ExampleAPI < Grape::API
  # grape instrumentation would integrate automatically,
  # but in this case, we need to do it manually:
  use OpenTelemetry::Adapters::Rack::Middlewares::TracerMiddleware

  get '/' do
    'root'
  end
end