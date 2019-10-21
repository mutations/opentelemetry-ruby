# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require_relative 'strict_mode/registry'

module OpenTelemetry
  module StrictMode
    @registry ||= Registry.new

    def self.enable
      @registry.each do |registered|
        registered.prepend(registered::Strict) if registered.const_get('Strict')
      end
    end

    def self.registry
      @registry
    end

    def self.register(cls)
      @registry << cls
    end
  end
end
