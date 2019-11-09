# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Faraday
      module Patches
        module FaradayConnectionOptions
          def new_builder(block)
            super.tap do |builder|
              builder.use(:open_telemetry)
            end
          end
        end
      end
    end
  end
end
