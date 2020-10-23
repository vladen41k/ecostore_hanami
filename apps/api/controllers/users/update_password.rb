# frozen_string_literal: true

module Api
  module Controllers
    module Users
      class UpdatePassword
        include Api::Action
        include AuthenticateUserHelper
        include Helpers::ErrorsHelper

        def call(params)
          if current_user
            result = UsersServices::UpdateUserPasswordService.new.call(params)

            update_user(result)
          else
            status 400, { data: { user: 'must be authenticated' } }.to_json
          end
        end

        private

        def update_user(result)
          if result.success?
            status 200, result.success
          else
            status 400, { data: errors_messages(result) }.to_json
          end
        end
      end
    end
  end
end
