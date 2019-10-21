# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::Strict do
  class TestParentClass
    include OpenTelemetry::Strict
  end

  it 'registers the parent class when included' do
    OpenTelemetry::StrictMode.registry.must_include(TestParentClass)
  end
end
