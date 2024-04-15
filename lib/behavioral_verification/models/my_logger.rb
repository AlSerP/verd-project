module BehavioralVerification
  module Models
    # Custom Logger
    class MyLogger
      def self.logger
        if @_logger.nil?
          @_logger = Logger.new $stdout
          @_logger.level = Logger::INFO
          @_logger.datetime_format = "%a %d-%m-%Y %H%M "
        end
        @_logger
      end
    end
  end
end
