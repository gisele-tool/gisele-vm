$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-vm'
require_relative 'fixtures/kernel'
require_relative 'fixtures/fake_component'

def fixtures
  Path.dir/:fixtures
end

(Path.dir/'unit/shared').glob("**/*.rb").each{|f| require(f.without_extension)}

module SpecHelpers

  class FakeEventManager < Gisele::VM::Component
    attr_reader :events
    def event(event)
      @events ||= []
      @events << event
    end
  end

  def observed_events
    vm.event_manager.events
  end

  def an_event
    Gisele::VM::Event.new(Gisele::VM::Prog.new(:puid => 17), :hello, [ "world" ])
  end

  def vm(bc = nil)
    @vm ||= begin
      vm = Gisele::VM.new(bc || [:gvm]) do |vm|
        vm.proglist      = Gisele::VM::ProgList.memory
        vm.event_manager = FakeEventManager.new
      end
      vm.connect
      vm.proglist.clear
      vm
    end
  end

  def list
    @list ||= vm.proglist
  end

  def kernel(bc = nil)
    @k ||= vm(bc).kernel
  end

  def runner(*args)
    bc   = args.find{|x| Gisele::VM::Bytecode===x}
    prog = args.find{|x| Integer===x or Gisele::VM::Prog===x}
    prog = list.fetch(prog) if Integer===prog
    @kernel ||= kernel(bc).runner(prog)
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

  def sqlite_protocol
    Gisele::VM::ProgList::Sqldb.sqlite_protocol
  end

  def sqlite_memory
    {:uri => "#{sqlite_protocol}:memory"}
  end

end

RSpec.configure do |c|
  c.extend  SpecHelpers
  c.include SpecHelpers
end
