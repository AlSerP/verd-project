module BehavioralVerification
  module Models
    # Keyboard Fingerpring
    class KFP
      include Mongoid::Document

      autoload :SymbolStat, "behavioral_verification/models/kfp/symbol_stat"

      field :user_id, type: String

      has_many :symbols, class_name: "BehavioralVerification::Models::SymbolStat"
      def records_number
        num = 0
        symbols.each do |sym|
          sym.pairs.each do |p|
            num += p.records_number
          end
        end

        num
      end
    end
  end
end
