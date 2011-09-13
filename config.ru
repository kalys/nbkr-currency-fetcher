require 'rubygems'
require 'bundler'
require 'open-uri'

Bundler.require :app

require './nbkr_backend'
run Nbkr::Application
