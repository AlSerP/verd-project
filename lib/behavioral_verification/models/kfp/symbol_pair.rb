module BehavioralVerification
  module Models
    # The second symbol in pair with statistical information
    class SymbolPair
      include Mongoid::Document
      belongs_to :stat, class_name: "BehavioralVerification::Models::SymbolStat"

      field :char, type: String
      field :time, type: Float # time in ms
      field :records_number, type: Integer, default: 0

      def update_time(add_time)
        new_time = records_number.zero? ? add_time : (time * records_number + add_time) / (records_number + 1)
        write_attribute(:time, new_time)
        write_attribute(:records_number, records_number + 1)

        save
      end
    end
  end
end
