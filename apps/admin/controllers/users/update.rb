# frozen_string_literal: true

module Admin
  module Controllers
    module Users
      class Update
        include Admin::Action
        include Helpers::ErrorsHelper
        include AuthenticateAdminHelper

        def call(params)
          if current_admin
            result = UsersServices::UpdateUserService.new.call(params, true)

            result.success? ? status(200, result.success) : status(400, { data: errors_messages(result) }.to_json)
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end
