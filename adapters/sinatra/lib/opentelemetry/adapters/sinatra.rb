# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Sinatra
      module_function

      TRACER_NAME = 'sinatra'
      TRACER_VERSION = Gem.loaded_specs[TRACER_NAME].version.to_s

      def install(config = {name: TRACER_NAME, version: TRACER_VERSION})
        require_relative 'sinatra/adapter'
        Sinatra::Adapter.install(config)
      end
    end
  end
end