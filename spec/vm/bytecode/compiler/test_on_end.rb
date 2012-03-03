require 'spec_helper'
module Gisele
  class VM
    class Bytecode
      describe Compiler, "on_end" do

        let(:compiler){ Compiler.new }

        subject{
          compiler.on_end(ts.ith_state(3))
          compiler.builder.to_a
        }

        it 'generates the expected bytecode' do
          expected = [:gvm,
            [:block, :s3,
              [:end],
              [:save],
            ]
          ]
          subject.should eq(expected)
        end

      end
    end
  end
end
