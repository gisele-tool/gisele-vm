module Gisele
  class VM
    shared_examples_for "a ProgList" do

      context "when freshly created" do
        it 'allows connecting and disconnecting' do
          subject.connect(vm)
          subject.disconnect
        end
      end

      context 'when connected' do

        before(:all) do
          subject.connect(vm)
          subject.clear
          subject.should be_empty
        end

        after(:all) do
          subject.clear
          subject.should be_empty
          subject.disconnect
        end

        before do
          @puid1 = subject.save(Prog.new)
          @puid2 = subject.save(Prog.new)
          subject.should_not be_empty
        end

        let(:puid1){ @puid1                }
        let(:prog1){ subject.fetch(@puid1) }
        let(:puid2){ @puid2                }
        let(:prog2){ subject.fetch(@puid2) }
        let(:puids){ [puid1, puid2] }
        let(:progs){ [prog1, prog2] }

        it 'allows saving fresh new Prog instances' do
          prog1.should be_a(Prog)
          default = Prog.new.to_hash
          default[:puid] = default[:parent] = default[:root] = puid1
          default.should eq(prog1.to_hash)
        end

        it 'allows saving Prog instances' do
          prog1.pc = :s18
          subject.save(prog1)
          subject.fetch(puid1).pc.should eq(:s18)
        end

        it 'allows saving an array of Prog instances' do
          progs.each{|p| p.pc = :s18}
          subject.save(progs)
          puids.each{|p| subject.fetch(p).pc.should eq(:s18)}
        end

        it 'distributes a Threadsafe instance if requested' do
          subject.threadsafe.should be_a(ProgList)
        end
      end

    end
  end
end
