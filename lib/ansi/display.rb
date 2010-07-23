module ANSI
  # Defines ANSI codes for changing screen resolution. Sequences with the following names are created:
  #
  # * erase_display, clear_display, clear, cls
  #   * Clears the screen.
  # * erase_line, clear_line, clr
  #   * Erases a line beginning with the cursor position.
  # * set_mode, mode
  #   * Sets a particular display mode. Expects a numeric value.
  # * unset_mode, reset_mode
  #   * Resets a specified display mode. Expects a numeric value.
  #
  #   set_40x25m      - enters 40x25 monochrome mode.
  #   set_40x25       - enters 40x25 color mode.
  #   set_80x25m      - enters 80x25 monochrome mode.
  #   set_320x200_4   - enters 320x200 4-color mode.
  #   set_320x200m    - enters 320x200 monochrome mode.
  #   set_320x200     - enters 320x200 color mode.
  #   set_320x200_256 - enters 320x200 256-color mode.
  #   set_640x200m    - enters 640x200 monochrome mode.
  #   set_640x200     - enters 640x200 color mode.
  #   set_640x350m    - enters 640x350 monochrome mode.
  #   set_640x350     - enters 640x350 color mode.
  #   set_640x480m    - enters 640x480 monochrome mode.
  #   set_640x480     - enters 640x480 color mode.
  #   
  #   All of the above modes also have an unset_ or reset_ counterpart.
  #   
  #   wrap   - turns on word wrapping.
  #   unwrap - turns off word wrapping.
  #
  module Display
    ANSI.define("erase_display", "clear_display", "clear", "cls") { "\e[2J" }
    ANSI.define("erase_line", "clear_line", "clr") { "\e[K" }
  
    # Various set and unset/reset methods for display modes.
    #   set_320x200, unset_320x200, reset_320x200, etc.
    { "set_" => 'h', '' => 'h', "unset_" => 'l', "reset_" => 'l'}.each do |prefix, symbol|
      ANSI.define("#{prefix}mode") { |value| "\e[=#{value || 0}#{symbol}" }
      
      %w(40x25m 40x25 80x25m 80x25 320x200_4 320x200m 640x200m).each_with_index do |mode, index|
        next if prefix == ""
        ANSI.define("#{prefix}#{mode}") { send("#{prefix}mode", index) }
        # (ie set_40x25m => 0, set_320x200_4 => 4)
      end
      %w(320x200 640x200 640x350m 640x350 640x480m 640x480 320x200_256).each_with_index do |mode, index|
        next if prefix == ""
        ANSI.define("#{prefix}#{mode}") { send("#{prefix}mode", index+13) }
      end
    end
    ANSI.define("wrap") { set_mode(7) }
    ANSI.define("unwrap") { unset_mode(7) }
  end
end