module BehavioralVerification
  module Models
    # The second symbol in pair with statistical information
    class SymbolPair
      include Mongoid::Document
      belongs_to :stat, class_name: "BehavioralVerification::Models::SymbolStat"

      field :char, type: String
      field :time, type: Float, default: 0 # time in ms
      field :standard_deviation, type: Float, default: 0.0
      field :records_number, type: Integer, default: 0

      def update(received_time)
        updated_r_number = records_number + 1
        new_time = (time * records_number + received_time) / updated_r_number
        new_standard_deviation = Math.sqrt(
          ((standard_deviation**2) * records_number + (received_time - new_time)**2) / updated_r_number
        )

        write_attribute(:time, new_time)
        write_attribute(:records_number, updated_r_number)
        write_attribute(:standard_deviation, new_standard_deviation)

        save
      end
    end
  end
end
