Stamina::Automaton.new do
  add_state :kind => :listen, :initial => true
  add_state :kind => :fork
  add_state :kind => :event
  add_state :kind => :end
  add_state :kind => :event
  add_state :kind => :end
  add_state :kind => :join
  add_state :kind => :end
  connect 0, 1, :symbol => :ping
  connect 1, 2, nil
  connect 2, 3, :symbol => :pong
  connect 1, 4, nil
  connect 4, 5, :symbol => :pang
  connect 3, 6, nil
  connect 5, 6, nil
  connect 6, 0, nil
  connect 0, 7, :symbol => :exit
  connect 1, 6, :symbol => :"(wait)"
end
