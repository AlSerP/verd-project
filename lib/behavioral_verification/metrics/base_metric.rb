module BehavioralVerification::Metrics
  class BaseMetric
    def initialize(user, logging=true)
      @user = user
      @logging = logging
    end

    def update(data)
      bm = Benchmark.measure do
        begin
          no_log_update(data)
        rescue Exception => e
          exception = e
        end
      end
      
      if exception
        log(message: 'Updated metric data', time: bm)
      else
        log_exception(exception: exception)
      end

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
        log(verification_result: trustness, time: bm)
      else
        log_exception(exception: exception)
      end

      trustness
    end

    private

    def no_log_verificate(data); end
    def no_log_update(data); end

    def log(params)
      if @logging
        MyLogger.logger.info params.merge({ class: 'Metrics::KeyboardFP'})
      end
    end

    def log_exception(params)
      if @logging
        MyLogger.logger.error params.merge({ class: 'Metrics::KeyboardFP' })
      end
    end
  end
end
