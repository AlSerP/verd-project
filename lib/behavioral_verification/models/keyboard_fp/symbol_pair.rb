module BehavioralVerification::Models::KeyboardFP
  class SymbolPair
    include Mongoid::Document

    field :char, type: String
    field :time, type: Float # time in ms 
  end
end
