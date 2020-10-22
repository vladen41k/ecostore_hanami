# frozen_string_literal: true

module Admin
  module Controllers
    module Users
      class CreateSession
        include Admin::Action
        include Helpers::ErrorsHelper

        def call(params)
          result = AdminsServices::CreateAdminSessionService.new.call(params)

          result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
        end

      end
    end
  end
end
