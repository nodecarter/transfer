require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)
require 'minitest/autorun'
require 'mocha/setup'
require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new

require File.expand_path '../../lib/transfer', __FILE__
