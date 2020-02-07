# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module ActiveSupport
      class Adapter < OpenTelemetry::Instrumentation::Adapter
        install do |config|
          require_dependencies
        end

        present do
          defined?(::ActiveSupport)
        end
      end
    end
  end
end
