require 'spec_helper'

describe ANSI::Cursor do
  include ANSI
  
  it "should save cursor position" do
    save_cursor_position.should == "\e[s"
  end
  
  it "should restore cursor position" do
    restore_cursor_position.should == "\e[u"
  end

  context "#move_up" do
    it "should move up (2)" do
      move_up(2).should == "\e[2A"
    end
    
    it "should move up ()" do
      move_up().should == "\e[1A"
    end
  end
  
  context "#move_to" do
    it "should change cursor position (1, 2)" do
      move_to(1, 2).should == "\e[2;1H"
    end
    
    it "should change cursor position (1)" do
      move_to(1).should == "\e[0;1H"
    end
    
    it "should change cursor position ()" do
      move_to.should == "\e[0;0H"
    end
  end
end
