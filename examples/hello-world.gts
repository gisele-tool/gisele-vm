Stamina::Automaton.new do
  add_state :kind => :event, :initial => true
  add_state :kind => :event
  connect 0, 1, :symbol => :hello
  connect 1, 0, :symbol => :world
end
