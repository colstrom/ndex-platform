#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'webmachine'
require 'pidfile'

require_relative 'lib/resources'

PidFile.new piddir: '.'

# Enable tracing on all resources.
class Webmachine::Resource
  def trace?
    true
  end
end

API = Webmachine::Application.new do |app|
  app.routes do
    add ['trace', :*], Webmachine::Trace::TraceResource
    add ['index'], IndexResource
  end

  app.configure do |config|
    config.ip = '0.0.0.0'
    config.port = '9001'
    config.adapter = :Reel
  end
end

API.run
