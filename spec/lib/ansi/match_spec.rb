require 'spec_helper'

describe ANSI::Match do
  include ANSI
# [ #<ANSI::Match:0x102162cd8 @args=["31"], @codes=[SET_COLOR, RED]>,
#   #<ANSI::Match:0x101598c68 @args=["0"], @codes=[SET_COLOR, RESET_COLOR, REGULAR, VT100_CHAR_ATTRS_OFF]>
# ]
  
  subject { s = ANSI::Match.new("31"); s.codes << ANSI::SET_COLOR << ANSI::RED; s }
  
  it "should inspect more legibly" do
    subject.inspect.should == '#<ANSI::Match(SET_COLOR|RED) args=["31"]>'
  end
  
  it "should equal any code it contains" do
    subject.should == ANSI::SET_COLOR
    subject.should == ANSI::RED
  end
  
  it "should not equal codes it does not contain" do
    subject.should_not == ANSI::GREEN
  end
  
  it "should equal identical copies of itself" do
    subject.should == subject.dup
  end
  
  it "should equal constants that are the same code with a different name" do
    subject.should == ANSI::COLOR
  end
  
  context "with a copy of itself with different args" do
    before(:each) { @copy = ANSI::Match.new("32"); @copy.codes << ANSI::SET_COLOR << ANSI::RED }
    
    it "should not equal the copy" do
      subject.should_not == @copy
    end
  end

  context "with a copy of itself with different codes" do
    before(:each) { @copy = ANSI::Match.new("31"); @copy.codes << ANSI::GREEN }
    
    it "should not equal the copy" do
      subject.should_not == @copy
    end
  end
  
  context "with any other object" do
    it "should not equal the object" do
      subject.should_not == 1
    end
  end
end