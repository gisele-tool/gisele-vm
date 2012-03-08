module Gisele
  class VM
    describe Event, "to_s" do

      it 'works as expected' do
        expected = "start[17](Ping, 3)"
        Event.new(Prog.new(:puid => 17), :start, ["Ping", "3"]).to_s.should eq(expected)
      end

    end
  end
end
