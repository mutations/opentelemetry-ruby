# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sinatra
      module_function

      LIBRARY = 'sinatra'
      TRACER_VERSION = Gem.loaded_specs[LIBRARY]

      def install
        require_relative 'sinatra/adapter'
        Sinatra::Adapter.install
      end
    end
  end
end
