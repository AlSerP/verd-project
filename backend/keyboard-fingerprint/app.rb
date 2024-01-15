require 'sinatra/base'
require 'sinatra/json'
require 'json'

require_relative 'models/data_type_messages'
require_relative 'models/pair_stat'

class FingerprintApp < Sinatra::Base
  EMPTY_STAT = {m_time: 0.0, n: 0, s: 0}

  configure do
    set :symbol_pairs_unknown, {}
    set :symbol_pairs_known, {}
    enable :logging

    # logger.info "== FingerprintApp settings applied"
  end

  get '/' do
    erb :index
  end
  
  post '/keyboard/fingerprint' do
    logger.warning 'GOT EMPTY INTERVAL' and return unless params.include? :intervals 
    
    data = params[:intervals].values
    is_known = params[:is_known] == 'true'

    logger.info "INTERVALS #{data} and PASSWORD #{params[:password]} and KNOWN #{is_known}"

    update_pairs(data, is_known)
    # SymbolStats::Pairs.update_pairs(data, is_known)
    json result: "ok"
  end
  
  private

  def update_pairs(data, is_known)
    # if is_known
    #   symbol_pairs = settings.symbol_pairs_known
    # else
    #   symbol_pairs = settings.symbol_pairs_unknown
    # end
    
    symbol_pairs = settings.symbol_pairs_known
    (1...data.size).each do |i|
      s1, _ = unpack_symbol_data data[i-1]
      s2, new_time = unpack_symbol_data data[i]

      # Get or create symbol's pair data
      if symbol_pairs.include? s1
        symbol_pairs[s1][s2] = PairStat.new(s1, s2) unless symbol_pairs[s1].include? s2
      else
        symbol_pairs[s1] = {s2 => PairStat.new(s1, s2)}
      end

      # Update pair's data
      symbol_pairs[s1][s2].update(new_time)
    end

    save(symbol_pairs)
    logger.info "#{DataTypeMessages.message(is_known)} #{symbol_pairs}"
  end

  def save(pairs)
    File.open('symbol_pairs.json', 'w') do |f|
      f.write(pairs.to_json)
    end
  end

  def unpack_symbol_data(data)
    [data[0], data[1].to_f]
  end
end
