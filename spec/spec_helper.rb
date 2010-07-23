$DEBUG ||= ENV['DEBUG']
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sc-ansi'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before(:each) { ANSI.reset! if $DEBUG }
end
