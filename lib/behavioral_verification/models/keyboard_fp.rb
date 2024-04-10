module BehavioralVerification::Models::KeyboardFP
  class SymbolPair
    include Mongoid::Document

    field :user_id, type: String

    embeds_many :symbols, class_name: BehavioralVerification::Models::KeyboardFP::SymbolStat.to_s, as: fingerprint
  end
end
