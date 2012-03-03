module Gisele
  class VM

    class Error < StandardError
    end # class Error

    class InvalidBytecodeError < Error
    end # class InvalidBytecodeError

    class BadUsageError < Error
    end # BadUsageError

    class InvalidPUIDError < Error
    end # class InvalidPUIDError

  end # class VM
end # module Gisele
