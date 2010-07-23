describe Object do
  context "#instance_exec" do
    class Dummy
      def value
        :dummy_value
      end
    end
    
    subject { Dummy.new }
    
    it "should work with args" do
      # Block returns the value passed to it and the value of #value from the Dummy, in whose context
      # it will be eval'd.
      block = lambda { |a| [a, value] }
      
      subject.instance_exec(:arg_value, &block).should == [:arg_value, :dummy_value]
    end
  end
end