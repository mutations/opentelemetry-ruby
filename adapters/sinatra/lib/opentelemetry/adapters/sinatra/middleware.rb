# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sinatra
      class Middleware
        def call(env)
          tracer.in_span(
            env['sinatra.route'].split.last,
            attributes: { 'component': 'http',
                          'http.method': env.request_method },
            kind: :server
          ) do |span|
            span.set_attribute('http.url', env.url.to_s)

            app.call(env).tap do |status, headers, response_body|
              span.set_attribute('http.status_code', status)
              span.set_attribute('http.status_text', Rack::Utils::HTTP_STATUS_CODES[status])
            end
          end
        end

        private

        attr_reader :app

        def tracer
          OpenTelemetry.tracer_factory.tracer(Sinatra::LIBRARY, Sinatra::TRACER_VERSION)
        end
      end
    end
  end
end
