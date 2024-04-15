module BehavioralVerification
  module Metrics
    # Base verification metric class
    class BaseMetric
      def initialize(user_id, logging: true)
        @user_id = user_id
        @logging = logging
      end

      # Updates user data with
      # new behavioral data
      def update(data)
        exception = nil

        bm = Benchmark.measure do
          # begin
            no_log_update(data)
          # rescue Exception => e
          #   exception = e
          # end
        end

        if exception.nil?
          log(message: "Metric data has been updated", time: bm.real)
        else
          log_exception(exception: exception, time: bm.real)
        end
      end

      # Сalculates the level of confidence in the user
      # using current metric
      def verificate(data)
        exception = nil
        trustness = nil

        bm = Benchmark.measure do
          # begin
            trustness = no_log_verificate(data)
          # rescue Exception => e
          #   exception = e
          # end
        end

        if exception.nil?
          log(verification_result: trustness, time: bm.real)
        else
          log_exception(exception: exception, time: bm.real)
        end

        trustness
      end

      private

      def no_log_verificate(data); end
      def no_log_update(data); end

      def log_info
        {
          class: self,
          user_id: @user_id
        }
      end

      def log(params)
        return unless @logging

        BehavioralVerification::Models::MyLogger.logger.info params.merge(log_info)
      end

      def log_exception(params)
        return unless @logging

        BehavioralVerification::Models::MyLogger.logger.error params.merge(log_info)
      end
    end
  end
end
