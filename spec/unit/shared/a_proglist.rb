module Gisele
  class VM
    shared_examples_for "a ProgList" do

      def connect_and_clear
        subject.connect(vm)
        subject.clear
      end

      def disconnect_and_clear
        subject.clear
        subject.disconnect
      end

      describe "connect/disconnect" do
        it 'allows connecting and disconnecting' do
          subject.connect(vm)
          subject.disconnect
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
          unless ProgList::Threadsafe===subject
            subject.pick(:waitfor => :operator).should be_nil
          end
        end
      end

      describe 'to_relation' do
        before(:all) do
          connect_and_clear
          @enacted = subject.save(Prog.new :waitfor => :enacter)
          @worlded = subject.save(Prog.new :waitfor => :world)
        end
        after (:all){ disconnect_and_clear }

        it 'returns a Relation wil all Progs by default' do
          rel = subject.to_relation
          rel.project([:puid]).should eq(Relation(:puid => [ @enacted, @worlded ]))
        end

        it 'supports a restriction Hash argument' do
          rel = subject.to_relation(:waitfor => :enacter)
          rel.project([:puid]).should eq(Relation(:puid => @enacted))
        end
      end

    end
  end
end
