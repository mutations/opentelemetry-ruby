# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module StrictMode
    class Registry
      def initialize
        @data = []
        @mutex = Mutex.new
      end

      def <<(obj)
        @mutex.synchronize { @data << obj }
      end

      def each
        @mutex.synchronize do
          @data.each { |datum| yield(datum) }
        end
      end

      def include?(other)
        @mutex.synchronize { @data.include?(other) }
      end
    end
  end
end
