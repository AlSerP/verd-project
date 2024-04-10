module BehavioralVerification::Models::KeyboardFP
  class SymbolStat
    include Mongoid::Document

    field :char, type: String
    
    embeds_many :pairs, class_name: BehavioralVerification::Models::KeyboardFP::SymbolPair.to_s, as: :owner
  end
end