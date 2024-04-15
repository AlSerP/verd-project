module BehavioralVerification
  # Behavioral Verification models module
  module Models
    autoload :SymbolPair, "behavioral_verification/models/kfp"
  end
end

require_relative "models/kfp"
require_relative "models/kfp/symbol_pair"
require_relative "models/kfp/symbol_stat"

require_relative "models/my_logger"
