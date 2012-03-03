def ts
  Stamina::Automaton.new do |a|
    s0 = a.add_state :kind => :event, :initial => true
    s1 = a.add_state :kind => :listen
    s2 = a.add_state :kind => :end
    s3 = a.add_state :kind => :end
    a.connect(s0, s1, :symbol => :hello)
    a.connect(s1, s2, :symbol => :ping)
    a.connect(s1, s3, :symbol => :goodbye)
  end
end
