module Api
  module Controllers
    module AuthenticateUserHelper

      private

      def current_user
        @current_user ||= auth_user.success? ? auth_user.success : nil
      end

      def current_user_errors
        @current_user_errors ||= auth_user.success? ? nil : errors_messages(auth_user)
      end

      def auth_user
        @auth_user ||= UsersServices::AuthenticationUserService.new.call(@params)
      end

      def errors_messages(result)
        result.failure.try(:messages) || result.failure.try(:message) || result.failure
      end
    end
  end
end
