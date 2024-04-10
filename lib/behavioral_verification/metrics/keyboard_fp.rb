module BehavioralVerification::Metrics
  # Keyboard fingerprint metric
  class KeyboardFP < BaseMetric
    def initialize(user)
      super(user)

      @pairs = {}
      # средний уровень квадратичного отклонения
      @avg_s_d = 0
      # количество записей (символов)
      @n = 0
    end

    def push(pair_stat)
      s1 = pair_stat.s1
      s2 = pair_stat.s2
  
      if @pairs.include? s1
        @pairs[s1][s2] = pair_stat
      else
        @pairs[s1] = {s2 => pair_stat}
      end
  
      @n += pair_stat.n
    end

    def ready?
      @n >= KEYBOARD_FP_PERIOD
    end

    def update(data)
      no_log_update(data)

      log "Update result is #{@pairs}"
    end

    def verificate(data)
      # Проверяет вероятность ввода пароля владельцем
      # и возвращает уровень уверенности от 0 (не владелец) до 2 (владелец)
  
      bm = Benchmark.measure do
        begin
          trustness = no_log_verificate(data)
        rescue Exception => e
          exception = e
        end
      end
      
      if exception
        log {
          verification_result: trustness,
          time: bm
        }
      else
        log {

        }
      end

      trustness
    end

    def save_to_json()
      File.open('symbol_pairs.json', 'w') do |f|
        f.write(@pairs.to_json)
      end
    end

    private

    def no_log_verificate(data)
      sum_trustness = 0.0
  
      (1...data.size).each do |i|
        s1, _ = unpack_symbol_data data[i-1]
        s2, time = unpack_symbol_data data[i]
  
        if @pairs.include? s1 and @pairs[s1].include? s2
          pair = @pairs[s1][s2]
          p_t = pair_trustness(pair, time)
          log "Current pair trust #{p_t}"
          sum_trustness += p_t
        end
      end
  
      trustness = sum_trustness / data.size
    end

    def no_log_update(data)
      (1...data.size).each do |i|
        s1, _ = unpack_symbol_data(data[i-1])
        s2, new_time = unpack_symbol_data(data[i])
  
        # Get or create symbol's pair data
        if @pairs.include? s1
          @pairs[s1][s2] = PairStat.new(s1, s2) unless @pairs[s1].include? s2
        else
          @pairs[s1] = {s2 => PairStat.new(s1, s2)}
        end
  
        # Update pair's data
        @pairs[s1][s2].update(new_time)
        @n += 1
      end
    end

    def pair_trustness(pair, time)
      t_diff = (pair.avg_time - time).abs
      s_d = pair.s_d

      return 1.0 if t_diff <= s_d

      s_d.to_f / t_diff
    end

    def unpack_symbol_data(data)
      [data[0], data[1].to_f]
    end
  end
end
