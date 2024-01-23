require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'logger'

require_relative 'models/data_type_messages'
require_relative 'models/pair_stat'
require_relative 'models/user_stat'
require_relative 'models/my_logger'

class FingerprintApp < Sinatra::Base
  EMPTY_STAT = {m_time: 0.0, n: 0, s: 0}

  configure do
    begin
      f = File.open('symbol_pairs.json')
      data = JSON.load f
      f.close

      set :symbol_pairs_known, UserStat.from_json(data)

      puts "== FingerprintApp load data #{settings.symbol_pairs_known}"
    rescue Errno::ENOENT => e
      puts "== Can't find symbol_pairs.json"

      set :symbol_pairs_known, UserStat.new
    end

    set :symbol_pairs_unknown, UserStat.new
    
    logger = MyLogger.logger
    set :logger, logger
  end

  get '/' do
    is_trained = settings.symbol_pairs_known.ready?

    erb :index, {is_trained: :is_trained}
  end
  
  post '/keyboard/fingerprint' do
    logger.warning 'GOT EMPTY INTERVAL' and return unless params.include? :intervals 
    
    data = params[:intervals].values
    is_known = params[:is_known] == 'true'

    logger.info "INTERVALS #{data} and PASSWORD #{params[:password]} and KNOWN #{is_known}"

    msg = perform_data(data)

    json message: msg
  end
  
  private

  def perform_data(data)
    pairs = settings.symbol_pairs_known
    msg = ""

    if pairs.ready?
      res = pairs.verificate(data)
      msg = "Результат проверки #{res}"
    else
      pairs.update(data)
      pairs.save_to_json
      msg = "Ваши данные обновлены"
    end

    msg
  end
end
