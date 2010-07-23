module ANSI
  class Match
    attr_reader :codes, :args
    
    # An object is considered to be equal to an ANSI::Match if:
    # - it is an instance of ANSI::Match and both its arguments and relevant instances of ANSI::Code are equal.
    # - it is an instance of ANSI::Code which is contained in the #codes array of this ANSI::Match.
    def ==(other)
      if other.kind_of?(ANSI::Match)
        other.codes == @codes && other.args == @args
      elsif other.kind_of?(ANSI::Code)
        @codes.include?(other)
      else
        false
      end
    end
    
    def inspect
      "#<ANSI::Match(#{@codes.join("|")}) args=#{@args.inspect}>"
    end
    
    alias to_s inspect
    
    def initialize(*args)
      args.flatten!
      @args = args
      @codes = []
    end
    
    # Shorthand for adding an ANSI::Code to the #codes array.
    def <<(code)
      @codes << code
    end
  end
end