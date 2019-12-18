# frozen_string_literal: true

# Copyright 2019 OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Adapters
    module Rails
      class Adapter
        class << self
          def install(config = {})
            @config = config
          end
        end

        def install
          add_active_support_before_initialize_hook
          add_active_support_after_initialize_hook

          :installed
        end

        private

        def add_active_support_before_initialize_hook
          # note: run_once is available after rails-5.2
          ::ActiveSupport.on_load(:before_initialize,
                                  run_once: true,
                                  yield: true) do |app|
            before_initialize_hook(app)
          end
        end

        def before_initialize_hook(app)
          # TODO: do once
          add_rack_middleware(app)
          # TODO: exception middleware
          # add_exception_middleware
        end

        def add_active_support_after_initialize_hook
          # note: run_once is available after rails-5.2
          ::ActiveSupport.on_load(:after_initialize,
                                  run_once: true,
                                  yield: true) do |app|
            after_initialize_hook(app)
          end
        end

        def after_initialize_hook(app)
          # TODO: do once
          activate_rack
          activate_active_support
          activate_action_pack
          activate_action_view
          activate_active_record
        end

        def add_rack_middleware(app)
          require 'opentelemetry/adapters/rack/middlewares/tracer_middleware'
          app.middleware.insert_before(0, Rack::Middlewares::TracerMiddleware)
        end

        def activate_rack
        end

        def activate_active_support
        end

        def activate_action_pack
        end

        def activate_action_view
        end

        def activate_active_record
        end
      end
    end
  end
end
