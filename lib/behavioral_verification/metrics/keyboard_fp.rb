module BehavioralVerification
  module Metrics
    # Keyboard fingerprint metric
    class KeyboardFP < BaseMetric
      attr_reader :kfp, :pairs, :symbols, :n

      def initialize(user_id, logging: true)
        super(user_id, logging: logging)

        @kfp = BehavioralVerification::Models::KFP.where(user_id: @user_id)
        @kfp = @kfp[0].nil? ? BehavioralVerification::Models::KFP.create(user_id: @user_id) : @kfp[0]
        @pairs = JSON.parse @kfp.symbols.to_json
        @n = @kfp.records_number
      end

      def ready?
        @n >= KEYBOARD_FP_PERIOD
      end

      # def save_to_json()
      #   File.open('symbol_pairs.json', 'w') do |f|
      #     f.write(@pairs.to_json)
      #   end
      # end

      private

      def push(pair_stat)
        s1 = pair_stat.s1
        s2 = pair_stat.s2

        if @pairs.include? s1
          @pairs[s1][s2] = pair_stat
        else
          @pairs[s1] = { s2 => pair_stat }
        end

        @n += pair_stat.n
      end

      def no_log_verificate(data)
        sum_trustness = 0.0

        (1...data.size).each do |i|
          s1, = unpack_symbol_data data[i - 1]
          s2, time = unpack_symbol_data data[i]

          current_symbol = @kfp.symbols.where.find_by(char: s1)
          current_pair = current_symbol.pairs.find_by(char: s2)

          next if current_symbol.nil?
          next if current_pair.nil?

          pair_trustness = pair_trustness(current_pair, time)
          # log "Current pair trust #{p_t}"
          sum_trustness += pair_trustness
        end

        sum_trustness / data.size
      end

      def no_log_update(data)
        (1...data.size).each do |i|
          s1, = unpack_symbol_data(data[i - 1])
          s2, new_time = unpack_symbol_data(data[i])

          # Get or create symbol's pair data
          current_symbol = @kfp.symbols.find_or_create_by(char: s1)
          current_pair = current_symbol.pairs.find_or_create_by({ char: s2 })

          # Update pair's data
          current_pair.update(new_time)
          @n += 1

          log message: "Updated", s1: s1, s2: s2
        end
      end

      def pair_trustness(pair, time)
        t_diff = (pair.time - time).abs
        s_d = pair.standard_deviation

        return 1.0 if t_diff <= s_d

        s_d / t_diff
      end

      def unpack_symbol_data(data)
        [data[0], data[1].to_f]
      end
    end
  end
end
