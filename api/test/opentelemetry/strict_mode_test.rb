# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::StrictMode do
  StrictMode = OpenTelemetry::StrictMode

  it 'contains a registry' do
    StrictMode.registry.must_be_kind_of(StrictMode::Registry)
  end

  describe 'with a test registry' do
    @original_registry = nil

    class TestStrictParent
      module Strict
        def strict_method; end
      end

      def regular_method; end
    end

    before do
      # Update `StrictMode` with a new registry instance to prevent polluting tests
      @original_registry = OpenTelemetry::StrictMode.registry
      StrictMode.instance_variable_set(:@registry, OpenTelemetry::StrictMode::Registry.new)
    end

    after do
      # Replace the original registry instance
      StrictMode.instance_variable_set(:@registry, @original_registry)
    end

    it 'registers a class' do
      StrictMode.register(TestStrictParent)
      StrictMode.registry.include?(TestStrictParent)
    end

    it 'enables strict mode for all registered classes' do
      parent = TestStrictParent.new
      parent.must_respond_to(:regular_method)
      parent.wont_respond_to(:strict_method)

      StrictMode.registry << TestStrictParent
      StrictMode.enable

      parent.must_respond_to(:regular_method)
      parent.must_respond_to(:strict_method)
    end
  end
end
