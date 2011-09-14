require 'rubygems'
require 'bundler'
require 'open-uri'

Bundler.require

require './lib/cache'
require './nbkr_backend'
run Nbkr::Application
