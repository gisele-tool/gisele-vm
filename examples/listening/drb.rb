require 'gisele-vm'

class Listener
  include DRb::DRbUndumped
  
  def call(event)
    prog      = event.prog
    type      = event.type
    task_name = event.args.first
    puts "#{task_name}:#{type} (#{prog.root})"
  end
  
end

Gisele::VM.drb_client do |vm|

  # Subscribe our listener
  vm.subscribe Listener.new

  # trap CTRL-C and shut down the VM
  trap('INT'){
    vm.info "Interrupt on user request (graceful shutdown)."
    vm.stop
  }
end
