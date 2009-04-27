require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'active_support/core_ext/hash'
require 'test/unit'
gem 'thoughtbot-shoulda'
require 'shoulda'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
