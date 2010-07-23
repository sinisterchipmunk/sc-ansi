require File.join(File.dirname(__FILE__), "ansi")

# This file is here as a way to differentiate between the sc-ansi gem and any other ANSI-related gem you may be
# harboring. If this is not true in your case, feel free to require 'ansi' directly. The other reason for this file
# is to take some confusion out of loading the gem from a Rails project, as Rails will automatically load a file
# whose name matches the gem. Yay.
module ANSI

end
