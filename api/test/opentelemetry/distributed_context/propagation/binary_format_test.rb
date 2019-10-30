# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::DistributedContext::Propagation::BinaryFormat do

  let(:span_context_class) { OpenTelemetry::Trace::SpanContext }
  let(:span_context) { span_context_class.new }
  let(:subject_class) { OpenTelemetry::DistributedContext::Propagation::BinaryFormat }
  let(:formatter) { subject_class.new }
  let(:bytes) { }

  describe '#to_bytes' do
    it { formatter.to_bytes(span_context) }
  end

  describe '#from_bytes' do
    it { formatter.from_bytes(bytes) }
  end
end
