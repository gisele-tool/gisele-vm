$:.unshift File.expand_path('../../../lib', __FILE__)
require 'gisele-vm'

class Listener

  def call(event)
    prog      = event.prog
    type      = event.type
    task_name = event.args.first
    puts "SEEN: #{task_name}:#{type} (#{prog.puid} with parent #{prog.root})"
  end
  
end

unless ARGV.size == 1
  puts "Usage: ruby vm_listen.rb GIS_FILE"
  exit
end

# Compile the .gis file as a bytecode
gis_file = Path(ARGV.first)
bytecode = Gisele::VM.compile(gis_file)

Gisele::VM.new(bytecode) do |vm|
  vm.logger = Logger.new(STDOUT)
  vm.logger.level = Logger::INFO

  # Register an enacter (force maximal progress by starting tasks)
  vm.register Gisele::VM::Enacter.new

  # Register the interactive console
  vm.register Gisele::VM::Console.new

  # Subscribe our listener to the VM events
  vm.subscribe Listener.new

  # trap CTRL-C and shut down the VM
  trap('INT'){
    vm.info "Interrupt on user request (graceful shutdown)."
    vm.stop
  }
end.run
