module Gisele
  class VM

    class Error < StandardError
    end # class Error

    class InvalidBytecodeError < Error
    end # class InvalidBytecodeError

    class InvalidLabelError < Error
    end # class InvalidLabelError

    class InvalidInputError < Error
    end # class InvalidInputError

    class InvalidStateError < Error
    end # class InvalidStateError

    class BadUsageError < Error
    end # BadUsageError

    class InvalidPUIDError < Error
    end # class InvalidPUIDError

  end # class VM
end # module Gisele
