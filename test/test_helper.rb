require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)
require 'minitest/autorun'
require 'mocha/setup'
require 'minitest/reporters'
MiniTest::Reporters.use!

require 'database_cleaner'
DatabaseCleaner[:sequel].strategy = :truncation

require File.expand_path '../../lib/transfer', __FILE__


class MiniTest::Unit::TestCase
end
