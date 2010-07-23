require 'spec_helper'

describe ANSI::Display do
  include ANSI
  
  it "should set 40x25m mode" do
    set_40x25m.should == "\e[=0h"
  end
  
  it "should unset 40x25m mode" do
    unset_40x25m.should == "\e[=0l"
  end
  
  it "should erase display" do
    erase_display.should == "\e[2J"
  end
  
  it "should erase line" do
    erase_line.should == "\e[K"
  end
end
