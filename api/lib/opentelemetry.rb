# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'logger'

require 'opentelemetry/error'
require 'opentelemetry/context'
require 'opentelemetry/correlation_context'
require 'opentelemetry/internal'
require 'opentelemetry/instrumentation'
require 'opentelemetry/metrics'
require 'opentelemetry/trace'
require 'opentelemetry/version'

# OpenTelemetry is an open source observability framework, providing a
# general-purpose API, SDK, and related tools required for the instrumentation
# of cloud-native software, frameworks, and libraries.
#
# The OpenTelemetry module provides global accessors for telemetry objects.
module OpenTelemetry
  extend self

  attr_writer :tracer_factory, :meter_factory, :correlations

  attr_accessor :logger

  # @return [Object, Trace::TracerFactory] registered tracer factory or a
  #   default no-op implementation of the tracer factory.
  def tracer_factory
    @tracer_factory ||= Trace::TracerFactory.new
  end

  # @return [Object, Metrics::MeterFactory] registered meter factory or a
  #   default no-op implementation of the meter factory.
  def meter_factory
    @meter_factory ||= Metrics::MeterFactory.new
  end

  # @return [Instrumentation::Registry] registry containing all known
  #  instrumentation
  def instrumentation_registry
    @instrumentation_registry ||= Instrumentation::Registry.new
  end

  # @return [Object, CorrelationContext::Manager] registered
  #   correlation context manager or a default no-op implementation of the
  #   manager.
  def correlations
    @correlations ||= CorrelationContext::Manager.new
  end

  # @return [Context::Propagation::Propagation] an instance of the propagation API
  def propagation
    @propagation ||= Context::Propagation::Propagation.new
  end

  self.logger = Logger.new(STDOUT)
end
