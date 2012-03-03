require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler, "on_listen" do

        let(:compiler){ Compiler.new }

        subject{
          compiler.on_listen(ts.ith_state(1))
          compiler.builder.to_a
        }

        it 'generates the expected bytecode' do
          expected = [:gvm,
            [:block, :s1,
              [:push, {:ping => :s2, :goodbye => :s3}],
              [:flip],
              [:get],
              [:skipnil],
              [:cont],
              [:save]
            ]
          ]
          subject.should eq(expected)
        end

      end
    end
  end
end
