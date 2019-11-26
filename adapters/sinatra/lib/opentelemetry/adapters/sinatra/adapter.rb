# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'sinatra'
require 'opentelemetry'

require_relative 'extensions/tracer_extension'

module OpenTelemetry
  module Adapters
    module Sinatra
      class Adapter
        class << self
          attr_reader :config,
                      :propagator,
                      :tracer

          def install(config = {})
            @config = config
            @propagator = tracer_factory.rack_http_text_format
            @tracer = config[:tracer] || default_tracer

            new.install
          end

          def registry
            @registry ||= {}
          end

          private

          def default_tracer
            tracer_factory.tracer(config[:name],
                                  config[:version])
          end

          def tracer_factory
            OpenTelemetry.tracer_factory
          end
        end

        def install
          register_tracer_extension
        end

        private

        def register_tracer_extension
          register_once(__method__) do
            ::Sinatra::Base.register Extensions::TracerExtension
          end
        end

        def register_once(label, &blk)
          return :registered_already if self.class.registry[label]

          yield

          self.class.registry[label] = true
        end
      end
    end
  end
end