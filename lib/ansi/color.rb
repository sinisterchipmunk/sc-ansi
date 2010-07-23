module ANSI
  # Defines various ANSI escape sequences relating to terminal color manipulation.
  #
  # A few low-level methods are defined:
  #
  # * set_color(*values)
  #   * takes 1 or more numeric color/attribute codes and produces the appropriate escape sequence.
  # * reset_color
  #   * takes no arguments and resets terminal color and attributes to normal.
  #
  # A number of higher-level methods are defined. None of them take any arguments, and they have the effect
  # that their name implies:
  #
  # Attribute methods:
  #   regular    (same as reset_color)
  #   bold
  #   underscore
  #   blink
  #   reverse_video
  #   concealed
  #
  # Foreground color methods:
  #   black   / fg_black
  #   red     / fg_red
  #   green   / fg_green
  #   yellow  / fg_yellow
  #   blue    / fg_blue
  #   magenta / fg_magenta
  #   cyan    / fg_cyan
  #   white   / fg_white
  #
  # Background color methods:
  #   bg_black
  #   bg_red
  #   bg_green
  #   bg_yellow
  #   bg_blue
  #   bg_magenta
  #   bg_cyan
  #   bg_white
  #
  # Every combination of the above is also generated as a single method call, producing results including (but not
  # limited to):
  #   regular_red
  #   bold_red
  #   underscore_red
  #   blink_red
  #   reverse_video_red
  #   concealed_red
  #   red_on_white / regular_red_on_white
  #   bold_red_on_white
  #   underscore_red_on_white
  #   blink_red_on_white
  #   . . .
  #   
  module Color
    class << ANSI
      # Defines the escape sequence, and then delegates to it from within String. This makes it possible to do things
      # like "this is red".red and so forth. Note that to keep a clean namespace, we'll undef and unalias all of this
      # at the end of the Color module.
      def define_with_extension(*names, &block) #:nodoc:
        _define(*names, &block)
        names.flatten.each do |name|
          String.class_eval { define_method(name) { ANSI.send(name) { self } } }
          Symbol.class_eval { define_method(name) { self.to_s.send(name) } }
        end
      end
      
      alias _define define #:nodoc:
      alias define define_with_extension #:nodoc:
    end
    
    ANSI.define("set_color",   "color") do |*values|
      block = values.last.kind_of?(Proc) ? values.pop : nil
      colr = "\e[#{values.join(";")}m"
      if block
        colr + block.call.to_s + reset_color
      else
        colr
      end
    end
    ANSI.define("reset_color", "reset") { color(0) }
    
    # Various combinations of colors and text attributes:
    #   bold, underscore, blink, reverse_video, concealed
    #   red, fg_red, bg_red, red_on_red, bold_red, bold_red_on_red
    # etc.
    colors = %w(black red green yellow blue magenta cyan white)
    attrs  = { "regular" => 0, "bold" => 1, "underscore" => 4, "blink" => 5, "reverse_video" => 7, "concealed" => 8 }
    
    attrs.each do |attr_name, attr_value|
      ANSI.define(attr_name) { |block| color(attr_value, &block) }              # 0-8
    end
    
    colors.each_with_index do |fg_name, fg_value|
      fg_value += 30
      ANSI.define(fg_name, "fg_#{fg_name}") { |block| color(fg_value, &block) } # 30-37  (ie red, fg_red)
      ANSI.define("bg_#{fg_name}") { |block| color(fg_value + 10, &block) }     # 40-47  (ie bg_red)
        
      attrs.each do |attr_name, attr_value|
        if attr_name.length > 0
          # (ie bold_red)
          ANSI.define("#{attr_name}_#{fg_name}") { |block| color(attr_value, fg_value, &block) }
        end
      end

      colors.each_with_index do |bg_name, bg_value|
        bg_value += 40
        # (ie red_on_blue)
        ANSI.define("#{fg_name}_on_#{bg_name}") { |block| color(fg_value, bg_value, &block) }
    
        attrs.each do |attr_name, attr_value|
          ANSI.define("#{attr_name}_#{fg_name}_#{bg_name}", "#{attr_name}_#{fg_name}_on_#{bg_name}") do |block|
            color(attr_value, fg_value, bg_value, &block)
          end
        end
      end
    end
    
    class << ANSI
      # Cleaning up after ourselves...
      alias define _define #:nodoc:
      undef define_with_extension
      undef _define
    end
  end
end
