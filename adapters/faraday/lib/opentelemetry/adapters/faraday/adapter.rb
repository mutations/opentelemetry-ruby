# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require_relative 'middleware'
require_relative 'patches/faraday_connection_options'
require_relative 'patches/rack_builder'

module OpenTelemetry
  module Adapters
    module Faraday
      class Adapter
        class << self
          attr_reader :config

          def install(config = {})
            @config = config
            new.install
          end

          def tracer
            OpenTelemetry.tracer_factory.tracer(config[:name], config[:version])
          end
        end

        def install
          register_middleware
          add_default_middleware
        end

        private

        def register_middleware
          ::Faraday::Middleware.register_middleware(open_telemetry: Middleware)
        end

        def add_default_middleware
          # TODO: Choose an option

          # Possibly cleaner but issues a warning: WARNING: Unexpected middleware set after the adapter. This won't be supported from Faraday 1.0.
          # ::Faraday::ConnectionOptions.prepend(Patches::FaradayConnectionOptions)

          # Not as clean but used by DataDog without warnings
          ::Faraday::RackBuilder.prepend(Patches::RackBuilder)
        end
      end
    end
  end
end
