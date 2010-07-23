class String
  prefix = "[]?><()#/"
  ANSI_ESCAPE_SEQUENCE_RX = /\e([#{Regexp::escape prefix}]?)([0-9;\{\?\}]*)([0-#{Regexp::escape 176.chr}])/
  
  # returns an array listing all detected ANSI sequences in self. These are instances of ANSI::Code.
  def ansi_sequences
    ANSI_ESCAPE_SEQUENCE_RX.each_match(self).collect do |match|
      ANSI.recognize(match[0])
    end
  end
  
  # Creates a new String that is a copy of this String. Takes a block
  # which will receive each occurrance of an ANSI escape sequence; the
  # escape sequence is replaced by the return value of the block.
  #
  # Example:
  #   ANSI.red { "hello" }.replace_ansi do |match|
  #     case match
  #       when RED then "(red)"
  #       when RESET_COLOR then "(normal)"
  #     end
  #   end
  #   #=> "(red)hello(normal)"
  #
  def replace_ansi
    copy = self.dup
    ANSI_ESCAPE_SEQUENCE_RX.each_match(copy).collect do |match|
      ansi_match = ANSI.recognize(match[0])
      result = yield ansi_match
      copy.gsub!(match[0], result)
    end
    copy
  end
end
