require 'drb'
module Gisele
  class VM
    module Proxy
      class Server < Component

        attr_reader :options

        def initialize(options = {})
          super()
          @options = Proxy.default_options.merge(options)
        end

        def connect
          super
          DRb.start_service options[:uri], vm
          info "VM proxy started at #{DRb.uri}."
        end

        def disconnect
          DRb.stop_service
          DRb.thread.join if DRb.thread
          super
        end

      end # Server
    end # module Proxy
  end # class VM
end # module Gisele
