Stamina::Automaton.new do
  add_state :kind => :event, :initial => true
  add_state :kind => :listen
  add_state :kind => :event
  add_state :kind => :event
  add_state :kind => :end
  connect 0, 1, :symbol => :hello
  connect 1, 2, :symbol => :ping
  connect 2, 1, :symbol => :pong
  connect 1, 3, :symbol => :goodbye
  connect 3, 4, :symbol => :ciao
end
