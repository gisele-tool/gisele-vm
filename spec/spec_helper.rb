$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-vm'
require_relative 'fixtures/kernel'
require_relative 'fixtures/vm'

def fixtures
  Path.dir/:fixtures
end

module SpecHelpers

  def events
    @events ||= []
  end

  def an_event
    Gisele::VM::Event.new(Gisele::VM::Prog.new(:puid => 17), :hello, [ "world" ])
  end

  def vm
    @vm ||= Gisele::VM.new do |vm|
      vm.proglist      = Gisele::VM::ProgList.memory
      vm.event_manager = proc{|evt|
        events << evt
      }
    end
  end

  def list
    vm.proglist
  end

  def kernel(prog = nil)
    @kernel ||= begin
      prog = list.fetch(prog) if Integer===prog
      vm.kernel(prog)
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
