module Gisele
  class VM
    shared_examples_for "a Storage" do

      def connect_and_clear
        subject.registered(vm)
        subject.connect
        subject.clear
      end

      def disconnect_and_clear
        subject.clear
        subject.disconnect
        subject.unregistered
      end

      describe "connect/disconnect" do
        it 'allows connecting and disconnecting' do
          subject.registered(vm)
          subject.connect
          subject.disconnect
          subject.unregistered
        end
      end

      describe 'fetch/save' do
        before(:all){ connect_and_clear    }
        after (:all){ disconnect_and_clear }

        before do
          @puid = subject.save(Prog.new)
          @prog = subject.fetch(@puid)
        end

        it 'allows saving fresh new Prog instances' do
          default = Prog.new.to_hash
          default[:puid] = default[:parent] = default[:root] = @puid
          default.should eq(@prog.to_hash)
        end

        it 'allows forking Prog instances' do
          c_puid = subject.save(Prog.new :parent => @puid, :root => @puid)
          child = subject.fetch(c_puid)
          child.puid.should eq(c_puid)
          child.parent.should eq(@puid)
          child.root.should eq(@puid)
        end

        it 'allows saving Prog instances' do
          @prog.pc    = :s18
          @prog.input = [:ended]
          s_puid  = subject.save(@prog)
          fetched = subject.fetch(s_puid)
          fetched.puid.should eq(@puid)
          fetched.pc.should eq(:s18)
          fetched.input.should eq([:ended])
        end

        it 'allows saving an array of Prog instances' do
          @prog.pc = :s19
          p1, p2 = subject.save([@prog, Prog.new])
          p1.should eq(@puid)
          subject.fetch(p1).pc.should eq(:s19)
          subject.fetch(p2).parent.should eq(p2)
        end
      end

      describe 'pick' do
        before(:all) do
          connect_and_clear
          @enacted = subject.save(Prog.new :waitfor => :enacter)
          @worlded = subject.save(Prog.new :waitfor => :world)
        end
        after (:all){ disconnect_and_clear }

        it 'allows picking a prog based on a restriction' do
          subject.pick(:waitfor => :enacter).should eq(subject.fetch(@enacted))
          subject.pick(:waitfor => :world).should eq(subject.fetch(@worlded))
        end

        it 'returns nil if picking cannot be served' do
          subject.pick(:waitfor => :operator).should be_nil
        end
      end

      describe 'to_relation' do
        before(:all) do
          connect_and_clear
          @enacted = subject.save(Prog.new :waitfor => :enacter, :pc => :s17)
          @worlded = subject.save(Prog.new :waitfor => :world,   :pc => :s18)
        end
        after (:all){ disconnect_and_clear }

        it 'returns a Relation wil all Progs by default' do
          rel = subject.to_relation
          expected = Relation([
            { :puid => @enacted, :waitlist => {}, :pc => :s17 },
            { :puid => @worlded, :waitlist => {}, :pc => :s18 }
          ])
          rel.project([:puid, :waitlist, :pc]).should eq(expected)
        end

        it 'supports a restriction Hash argument' do
          rel = subject.to_relation(:waitfor => :enacter)
          expected = Relation([
            { :puid => @enacted, :waitlist => {}, :pc => :s17 },
          ])
          rel.project([:puid, :waitlist, :pc]).should eq(expected)
        end
      end

    end
  end
end
