module Api
  module Controllers
    module ErrorsHelper

      def errors_messages(result)
        result.failure.try(:messages) || result.failure.try(:message) || result.failure
      end

    end
  end
end
