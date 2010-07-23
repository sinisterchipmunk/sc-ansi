require 'spec_helper'

describe ANSI do
  include ANSI
  
  context "#generate_sequence" do
    it "should work for 'blink'" do
      ANSI.generate_sequence('blink').should == "\e[5m"
    end
    
    it "should work for 'color'" do
      ANSI.generate_sequence('color').should == "\e[m"
    end
    
    it "should work for 'move'" do
      ANSI.generate_sequence('move').should == "\e[{?}{?}"
    end
    
    it "should work for 'move_up'" do
      ANSI.generate_sequence('move_up').should == "\e[{?}A"
    end
  end
  
  it "should define a new ANSI code with no arguments" do
    ANSI.define(:bizarro) { "\e[asdf" }
    bizarro.should == "\e[asdf"
  end
    
  context "for an ANSI code with 1 argument " do
    before(:each) { ANSI.define(:bizarro) { |a| "\e[#{a}a" } }
                                       
    it "should accept 0 arguments" do
      bizarro.should == "\e[a"
    end
    
    it "should accept 1 argument" do
      bizarro(1).should == "\e[1a"
    end
    
    it "should raise argument error with 2 arguments" do
      proc { bizarro(1, 2) }.should raise_error(ArgumentError)
    end
  end
end
