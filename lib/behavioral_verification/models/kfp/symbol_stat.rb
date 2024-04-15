module BehavioralVerification
  module Models
    # first symbol of pair
    class SymbolStat
      include Mongoid::Document

      field :char, type: String

      embeds_many :pairs, class_name: BehavioralVerification::Models::SymbolPair.to_s, as: :owner
    end
  end
end
