module ANSI
  # The object that calling ANSI.define(...) actually creates. This is managed internally and you should rarely
  # have to interface with it directly.
  class Code
    attr_reader :method_name, :arity, :block
    include ANSI
    
    # The name of this code. This is assigned to the first non-nil method name that this object uses.
    def name
      @name || (@method_name.kind_of?(String) ? @name = @method_name : @method_name.to_s).upcase
    end

    alias to_s name
    alias inspect name
    
    # Returns true if the other object is a kind_of ANSI::Code, *or* if the other object is a kind_of
    # ANSI::Match and this ANSI::Code is contained in that match. In other words:
    #
    #   code = ANSI::Code.new("a_code") {}
    #   match = ANSI::Match.new
    #
    #   code === match 
    #   #=> false
    #
    #   match << code
    #   code === match
    #   #=> true
    #
    def ===(other)
      if other.kind_of?(ANSI::Code)
        return true
      elsif other.kind_of?(ANSI::Match) && other == self
        return true
      else
        return false
      end
    end
    
    # Creates methods with the specified names which are aliases of #generate. These methods are singletons
    # of this instance of ANSI::Code, so adding method names using this method is only useful within the
    # context of this instance.
    #
    def add_methods!(*names) #:nodoc:
      names = names.flatten
      return if names.empty?
      @method_name ||= names.first.to_s

      names.each do |name|
        eigen.instance_eval do
          alias_method name, :generate
        end
      end
    end
    
    # Takes an optional list of method aliases, which are sent to #add_methods!, and a mandatory block argument
    # which is bound to the #generate method.
    def initialize(*names, &block)
      @arity = block.arity || 0
      @block = block
      
      eigen.instance_eval do
        if block.arity > 0
          # we need a list of arguments to pass to it.
          define_method "generate" do |*args|
            # this is to get around the warnings in Ruby 1.8
            if args.length > block.arity && block.arity == 1
              raise ArgumentError, "too many arguments (#{args.length} for #{block.arity})", caller
            end
            
            # omitted args should be made nil. We do this explicitly to silence warnings in 1.8.
            if (len = block.arity - args.length)
              len.times { args << nil }
            end
  
            instance_exec(*args, &block)
          end
        else
          define_method("generate", &block)
        end
      end

      add_methods! *names
    end
    
    private
    # the singleton class of this instance.
    def eigen #:nodoc:
      (class << self; self; end)
    end
  end
end
