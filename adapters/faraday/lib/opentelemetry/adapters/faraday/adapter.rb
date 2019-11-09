# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require_relative 'middleware'
require_relative 'patches/rack_builder'

module OpenTelemetry
  module Adapters
    module Faraday
      class Adapter
        def self.install
          new.install
        end

        def install
          register_middleware
          add_default_middleware
        end

        private

        def register_middleware
          ::Faraday::Middleware.register_middleware(opentelemetry: Middleware)
        end

        def add_default_middleware
          ::Faraday::RackBuilder.send(:prepend, Patches::RackBuilder)
        end
      end
    end
  end
end