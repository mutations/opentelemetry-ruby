# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  # The Context module provides per-thread storage.
  module Context
    extend self

    def get(key)
      storage[key]
    end

    def with(key, value)
      previous, storage[key] = storage[key], value
      yield value
    ensure
      storage[key] = previous
    end

    private

    def storage
      Thread.current[:__opentelemetry__] ||= {}
    end
  end
end
