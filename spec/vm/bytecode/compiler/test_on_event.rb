require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler, "on_event" do

        let(:compiler){ Compiler.new }

        subject{
          compiler.on_event(ts.ith_state(0))
          compiler.builder.to_a
        }

        it 'generates the expected bytecode' do
          expected = [:gvm,
            [:block, :s0,
              [:cont, :s1],
              [:save],
              [:push, []],
              [:event, :hello]
            ]
          ]
          subject.should eq(expected)
        end

      end
    end
  end
end
