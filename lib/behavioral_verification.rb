# frozen_string_literal: true

require 'mongoid'
# require 'kaminari/mongoid'

require_relative "behavioral_verification/version"
require_relative "behavioral_verification/metrics"

module BehavioralVerification
  class Error < StandardError; end
  # Your code goes here...
end
