module BehavioralVerification
  module Metrics
    KEYBOARD_FP_PERIOD = 100 # duration of training
  end
end

require_relative "metrics/base_metric"
require_relative "metrics/keyboard_fp"
