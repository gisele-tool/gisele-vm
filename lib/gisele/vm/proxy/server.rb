require 'drb'
module Gisele
  class VM
    module Proxy
      class Server
        include Component

        attr_reader :options

        def initialize(options = {})
          @options = Proxy.default_options.merge(options)
        end

        def connect(vm)
          super
          DRb.start_service options[:uri], vm
          info "VM proxy started at #{DRb.uri}"
        end

        def disconnect
          vm.info "Shutting down the DRb service"
          DRb.stop_service
          super
        end

      end # Server
    end # module Proxy
  end # class VM
end # module Gisele
