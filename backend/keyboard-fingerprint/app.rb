require "sinatra/base"
require "sinatra/json"

class FingerprintApp < Sinatra::Base
  configure do
    puts "GOOOOD"
    set :symbol_pairs, {}
    enable :logging
  end

  get '/' do
    erb :index
  end
  
  post '/keyboard/fingerprint' do
    logger.warning 'GOT EMPTY INTERVAL' and return unless params.include? :intervals 
    
    data = params[:intervals].values
    logger.info "INTERVALS #{data} and PASSWORD #{params[:password]}"

    update_pairs(data)
    json result: "ok"
  end
  
  private

  def update_pairs(data)
    # symbol_pairs = {}
    (1...data.size).each do |i|
      s1, _ = unpack_symbol_data data[i-1]
      s2, n_time = unpack_symbol_data data[i]

      # Get or create symbol's pair data
      if settings.symbol_pairs.include? s1
        settings.symbol_pairs[s1][s2] = {m_time: 0.0, n: 0} unless settings.symbol_pairs[s1].include? s2
      else
        settings.symbol_pairs[s1] = {s2 => {m_time: 0.0, n: 0}}
      end

      pair_data = settings.symbol_pairs[s1][s2]
      # Updata pair's data

      # s = pair_data[:s]  # Среднеквадратичное отклонение
      m_time = pair_data[:m_time]  # Среднее время 
      n = pair_data[:n]  # Количество записей
      n_u = n + 1  # Обновленное количество записей
      
      pair_data[:m_time] = (m_time * n + n_time) / n_u
      # pair_data[:s] = (s * n )
      pair_data[:n] = n_u

      settings.symbol_pairs[s1][s2] = pair_data
    end

    puts settings.symbol_pairs
  end

  def unpack_symbol_data(data)
    [data[0], data[1].to_f]
  end
end
