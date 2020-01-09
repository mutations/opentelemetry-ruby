# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'faraday'
require 'opentelemetry'

require_relative 'middlewares/tracer_middleware'
require_relative 'patches/rack_builder'

module OpenTelemetry
  module Adapters
    module Faraday
      class Adapter
        class << self
          attr_reader :config,
                      :propagator

          def install(config = {})
            @config = config
            # allow custom middleware to override default implementation:
            @config[:tracer_middleware] ||= Middlewares::TracerMiddleware
            @propagator = OpenTelemetry.tracer_factory.http_text_format

            new.install
          end

          def tracer
            @tracer ||= OpenTelemetry.tracer_factory.tracer(
              Faraday.name,
              Faraday.version
            )
          end
        end

        def install
          register_tracer_middleware
          use_middleware_by_default
        end

        private

        def register_tracer_middleware
          ::Faraday::Middleware.register_middleware(
            open_telemetry: self.class.config[:tracer_middleware]
          )
        end

        def use_middleware_by_default
          ::Faraday::RackBuilder.prepend(Patches::RackBuilder)
        end
      end
    end
  end
end
