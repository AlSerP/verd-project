module BehavioralVerification
  module Models
    # The second symbol in pair with statistical information
    class SymbolPair
      include Mongoid::Document

      field :char, type: String
      field :time, type: Float # time in ms
    end
  end
end
