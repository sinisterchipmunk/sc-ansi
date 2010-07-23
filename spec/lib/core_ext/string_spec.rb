describe String do
  include ANSI
  
  context "red { 'hello' }" do
    subject { ANSI.red { "hello" } }
    
    # this example is used in String core ext docs, so it better work!
    it "another replace_ansi case test" do
      subject.replace_ansi do |match|
        case match
          when ANSI::RED then "(red)"
          when ANSI::RESET_COLOR then "(normal)"
          else raise "not expected: #{match}"
        end
      end.should == "(red)hello(normal)"
    end
  end

  context "move_up + hello + move_down" do
    subject { move_up + " hello " + move_down }

    it "should return an array of ANSI escape sequences" do
      subject.ansi_sequences.should == [ ANSI::CURSOR_UP, ANSI::CURSOR_DOWN ]
    end
    
    # This example is used in README, so it better work!
    it "should replace ansi with custom content" do
      subject.replace_ansi do |match|  
        case match
          when ANSI::CURSOR_UP
            "(up)"
          when ANSI::CURSOR_DOWN
            "(down)"
          else
            raise "not expected: #{match}"
        end
      end.should == "(up) hello (down)"
    end
  end
  
  context "red + hello + reset_color" do
    subject { red { "hello there" } }

    it "should return an array of ANSI escape sequences" do
      subject.ansi_sequences.should == [ ANSI::RED, ANSI::RESET_COLOR ]
    end
  end

  context "the regular expression" do
    subject { String::ANSI_ESCAPE_SEQUENCE_RX }
  
    it "should be able to find args in 'blink_red_on_white'" do
      subject =~ blink_red_on_white
      $~[2].should == "5;31;47"
    end
  
    it "should match all defined escape sequences" do
      ANSI.dynamically_defined_methods.each do |method_name|
        sequence = ANSI.generate_sequence(method_name)
        begin
          subject.should match(sequence)
        rescue
          raise "Regexp #{String::ANSI_ESCAPE_SEQUENCE_RX} did not match sequence #{sequence.inspect} (for #{method_name})"
        end
      end
    end
  end
end