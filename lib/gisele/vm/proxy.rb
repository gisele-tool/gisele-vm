module Gisele
  class VM
    module Proxy

      def default_options
        { :uri => "druby://localhost:6789" }
      end
      module_function :default_options

    end # module Proxy
  end # class VM
end # module Gisele
require_relative 'proxy/server'
require_relative 'proxy/client'
