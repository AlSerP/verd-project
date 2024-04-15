module BehavioralVerification
  module Models
    # first symbol of pair
    class SymbolStat
      include Mongoid::Document

      autoload :SymbolPair, "behavioral_verification/models/kfp/symbol_pair"
      belongs_to :fingerprint, class_name: "BehavioralVerification::Models::KFP"

      field :char, type: String

      has_many :pairs, class_name: "BehavioralVerification::Models::SymbolPair"
    end
  end
end
