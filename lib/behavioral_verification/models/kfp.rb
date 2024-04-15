module BehavioralVerification
  module Models
    # Keyboard Fingerpring
    class KFP
      include Mongoid::Document

      field :user_id, type: String

      embeds_many :symbols, class_name: BehavioralVerification::Models::SymbolStat.to_s, as: :fingerprint
    end
  end
end
