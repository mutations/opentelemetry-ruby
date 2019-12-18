# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

require_relative '../../../../lib/opentelemetry/adapters/rails/adapter'

describe OpenTelemetry::Adapters::Rails::Adapter do
  let(:adapter) { OpenTelemetry::Adapters::Rails::Adapter }
  let(:instance) { adapter.new }
  let(:mock_app) { Class.new(Rails::Application) }

  before do
    # need to call Adapter.install before Adapter.new.install:
    adapter.install
  end

  describe '#install' do
    it 'installs' do
      _(instance.install).must_equal(:installed)

      ActiveSupport.run_load_hooks(:before_initialize, mock_app)
      ActiveSupport.run_load_hooks(:after_initialize, mock_app)
    end
  end
end
