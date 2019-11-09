# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Faraday
      module Patches
        module RackBuilder
          def adapter(*args)
            use(:open_telemetry) unless @handlers.any? do |handler|
              handler.klass == OpenTelemetry::Adapters::Faraday::Middleware
            end

            super
          end
        end
      end
    end
  end
end
