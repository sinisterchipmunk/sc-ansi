module ANSI
  # Defines ANSI escape codes relating to cursor movement:
  #
  #   move_to    - accepts an X and Y screen location; X is the column and Y is the row.
  #   move       - accepts a key (A, B, C, D) and an amount which defaults to 1.
  #   move_up    - accepts an amount, which defaults to 1.
  #   move_down  - accepts an amount, which defaults to 1.
  #   move_right - accepts an amount, which defaults to 1.
  #   move_left  - accepts an amount, which defaults to 1.
  #   
  #   save_cursor_position    - saves the current cursor position.
  #   restore_cursor_position - restores the cursor position.
  #
  module Cursor
    ANSI.define('move_to') { |x, y| "\e[#{y || 0};#{x || 0}H" }

    ANSI.define('move')       { |key, amt| "\e[#{amt || 1}#{key}" }
    ANSI.define('move_up',    'cursor_up',       'cuu') { |amt| move('A', amt) }
    ANSI.define('move_down',  'cursor_down',     'cud') { |amt| move('B', amt) }
    ANSI.define('move_right', 'cursor_forward',  'cuf') { |amt| move('C', amt) }
    ANSI.define('move_left',  'cursor_backward', 'cub') { |amt| move('D', amt) }

    ANSI.define('save_cursor_position')    { "\e[s" }
    ANSI.define('restore_cursor_position') { "\e[u" }
  end
end
