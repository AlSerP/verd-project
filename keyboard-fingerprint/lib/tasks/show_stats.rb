require 'json'
# require_relative '../symbol_stats'

class ShowStats
  class << self
    def show
      f = File.open('symbol_pairs.json')
      data = JSON.load f
      f.close

      pairs = []

      data.keys.each do |s1|
        data[s1].keys.each do |s2|
            pair_data = data[s1][s2]
            pairs.push PairStat.new(s1, s2, pair_data['avg_time'], pair_data['n'], 0.0, pair_data['s_d'])
        end
      end

      pairs_sorted = pairs.sort_by(&:avg_time)
      pairs_sorted.each { |pair| puts pair.to_s }
    end
  end
end