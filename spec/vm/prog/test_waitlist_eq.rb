require 'spec_helper'
module Gisele
  class VM
    describe Prog, 'waitlist=' do

      let(:prog){ Prog.new }

      it 'sets the waitlist when a Hash' do
        prog.waitlist = {:event => :label}
        prog.waitlist.should eq({:event => :label})
      end

      it 'coerces the waitlist when an Array' do
        prog.waitlist = [12, 13]
        prog.waitlist.should eq({12 => true, 13 => true})
      end

    end
  end
end
