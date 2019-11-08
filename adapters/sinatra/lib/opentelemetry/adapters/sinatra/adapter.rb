# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sinatra
      class Adapter
        def self.install
          new.install
        end

        def install
          register_middleware
        end

        private

        def register_middleware
          require_relative 'middleware'
          ::Sinatra.send(:register, Middleware)
        end
      end
    end
  end
end
