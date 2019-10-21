# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Trace
    # A text annotation with a set of attributes and a timestamp.
    class Event
      include OpenTelemetry::Strict

      module Strict
        def initialize(name:, attributes: nil, **)
          raise ArgumentError unless name.is_a?(String)
          raise ArgumentError unless OpenTelemetry::Strict::Checks.valid_attributes?(attributes)

          super
        end
      end

      EMPTY_ATTRIBUTES = {}.freeze

      private_constant :EMPTY_ATTRIBUTES

      # Returns the name of this event
      #
      # @return [String]
      attr_reader :name

      # Returns the frozen attributes for this event
      #
      # @return [Hash<String, Object>]
      attr_reader :attributes

      # Returns the timestamp for this event
      #
      # @return [Time]
      attr_reader :timestamp

      # Returns a new immutable {Event}.
      #
      # @param [String] name The name of this event
      # @param [optional Hash<String, Object>] attributes A hash of attributes for this
      #   event. Attributes will be frozen during Event initialization.
      # @param [optional Time] timestamp The timestamp for this event.
      #   Defaults to Time.now.
      # @return [Event]
      def initialize(name:, attributes: nil, timestamp: nil)
        @name = name
        @attributes = attributes.freeze || EMPTY_ATTRIBUTES
        @timestamp = timestamp || Time.now
      end
    end
  end
end
