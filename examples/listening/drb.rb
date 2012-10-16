require 'gisele-vm'

class Listener
  include DRb::DRbUndumped

  def initialize(vm)
    @vm = vm
  end
  attr_reader :vm
  
  def call(event)
    prog      = event.prog
    type      = event.type
    task_name = event.args.first
    puts "#{task_name}:#{type} (#{prog.puid}, #{prog.root})"
  end
  
end

Gisele::VM.drb_client do |vm|

  # Subscribe our listener
  vm.subscribe Listener.new(vm)

end
