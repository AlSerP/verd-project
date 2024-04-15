module BehavioralVerification
  module Metrics
    # Base verification metric class
    class BaseMetric
      def initialize(user, logging: true)
        @user = user
        @logging = logging
      end

      # Updates user data with
      # new behavioral data
      def update(data)
        bm = Benchmark.measure do
          begin
            no_log_update(data)
          rescue Exception => e
            exception = e
          end
        end

        if exception
          log(message: "Metric data has been updated", time: bm)
        else
          log_exception(exception: exception)
        end
      end

      # Сalculates the level of confidence in the user
      # using current metric
      def verificate(data)
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
        return unless @logging

        MyLogger.logger.info params.merge({ class: self.class.to_s })
      end

      def log_exception(params)
        return unless @logging

        MyLogger.logger.error params.merge({ class: self.class.to_s })
      end
    end
  end
end
