def ts
  Stamina::Automaton.new do |a|
    s0 = a.add_state :kind => :event, :initial => true
    s1 = a.add_state :kind => :listen
    s2 = a.add_state :kind => :event
    s3 = a.add_state :kind => :event
    s4 = a.add_state :kind => :end
    a.connect(s0, s1, :symbol => :hello)
    a.connect(s1, s2, :symbol => :ping)
    a.connect(s2, s1, :symbol => :pong)
    a.connect(s1, s3, :symbol => :goodbye)
    a.connect(s3, s4, :symbol => :ciao)
  end
end
