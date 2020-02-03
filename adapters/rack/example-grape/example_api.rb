# frozen_string_literal: true

# Copyright 2020 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

require 'grape'

class ExampleAPI < Grape::API
  get '/' do
    'root'
  end
end