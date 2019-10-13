# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'test_helper'

describe OpenTelemetry::Trace::Tracer do
  let(:invalid_span) { OpenTelemetry::Trace::Span::INVALID }
  let(:tracer) { OpenTelemetry::Trace::Tracer.new }

  describe '#current_span' do
    let(:current_span) { tracer.start_span('current') }

    it 'returns an invalid span by default' do
      tracer.current_span.must_equal(invalid_span)
    end

    it 'returns the current span when set' do
      OpenTelemetry::Context.with(
        OpenTelemetry::Trace::Tracer.const_get(:CONTEXT_SPAN_KEY),
        current_span
      ) do
        tracer.current_span.must_equal(current_span)
      end
    end
  end

  describe '#in_span' do
    it 'yields the new span' do
      tracer.in_span('wrapper') do |span|
        span.wont_equal(invalid_span)
        tracer.current_span.must_equal(span)
      end
    end
  end

  describe '#with_span' do
    it 'yields the passed in span' do
      wrapper_span = tracer.start_span('wrapper')
      tracer.with_span(wrapper_span) do |span|
        span.must_equal(wrapper_span)
        tracer.current_span.must_equal(wrapper_span)
      end
    end
  end

  describe '#start_root_span' do
    it 'requires a name' do
      proc { tracer.start_root_span(nil) }.must_raise(ArgumentError)
    end

    it 'returns a valid span' do
      span = tracer.start_root_span('root')
      span.context.must_be :valid?
    end
  end

  describe '#start_span' do
    let(:context) { OpenTelemetry::Trace::SpanContext.new }
    let(:invalid_context) { OpenTelemetry::Trace::SpanContext::INVALID }
    let(:parent) { tracer.start_span('parent') }

    it 'requires a name' do
      proc { tracer.start_span(nil) }.must_raise(ArgumentError)
    end

    it 'returns a valid span' do
      span = tracer.start_span('op', with_parent_context: context)
      span.context.must_be :valid?
    end

    it 'returns a span with a new context by default' do
      span = tracer.start_span('op')
      span.context.wont_equal(tracer.current_span.context)
    end

    it 'returns a span with the same context as the parent' do
      span = tracer.start_span('op', with_parent: parent)
      span.context.must_equal(parent.context)
    end

    it 'returns a span with a new context when passed an invalid context' do
      span = tracer.start_span('op', with_parent_context: invalid_context)
      span.context.wont_equal(invalid_context)
    end
  end

  describe '#binary_format' do
    it 'returns an instance of BinaryFormat' do
      tracer.binary_format.must_be_instance_of(
        OpenTelemetry::DistributedContext::Propagation::BinaryFormat
      )
    end
  end

  describe '#http_text_format' do
    it 'returns an instance of HTTPTextFormat' do
      tracer.http_text_format.must_be_instance_of(
        OpenTelemetry::DistributedContext::Propagation::HTTPTextFormat
      )
    end
  end
end
