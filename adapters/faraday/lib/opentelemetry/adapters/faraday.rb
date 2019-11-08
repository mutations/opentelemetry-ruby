# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Faraday
      module_function

      LIBRARY = 'faraday'
      TRACER_VERSION = Gem.loaded_specs[LIBRARY]

      def install
        require_relative 'faraday/adapter'
        Faraday::Adapter.install
      end
    end
  end
end
