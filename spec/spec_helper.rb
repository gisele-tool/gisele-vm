$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-vm'
require_relative 'fixtures/kernel'

def fixtures
  Path.dir/:fixtures
end

module SpecHelpers

  def vm
    @vm ||= Gisele::VM.new do |vm|
      vm.proglist = Gisele::VM::ProgList.memory
    end
  end

  def list
    vm.proglist
  end

  def kernel
    @kernel ||= begin
      Gisele::VM::Kernel.new vm
    end
  end

  def capture_io
    stdout, stderr = $stdout, $stderr
    $stdout, $stderr = StringIO.new, StringIO.new
    yield
    [$stdout.string, $stderr.string]
  ensure
    $stdout, $stderr = stdout, stderr
  end

  def measure
    t1 = Time.now
    yield
    t2 = Time.now
    puts "It took #{(t2-t1)} ms."
  end

end

RSpec.configure do |c|
  c.extend  SpecHelpers
  c.include SpecHelpers
end
