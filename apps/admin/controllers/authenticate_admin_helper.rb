# frozen_string_literal: true

module Admin
  module Controllers
    module AuthenticateAdminHelper

      private

      def auth_admin
        @auth_admin ||= AdminsServices::AuthenticationAdminService.new.call(@params)
      end

      def current_admin
        @current_admin ||= auth_admin.success? ? auth_admin.success : nil
      end

      def current_admin_errors
        @current_admin_errors ||= auth_admin.success? ? nil : errors_messages(auth_admin)
      end

      def errors_messages(result)
        result.failure.try(:messages) || result.failure.try(:message) || result.failure
      end
    end
  end
end
