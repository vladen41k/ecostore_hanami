module Api
  module Controllers
    module Users
      class CreateSession
        include Api::Action
        include ErrorsHelper

        def call(params)
          result = UsersServices::CreateUserSessionService.new.call(params)

          if result.success?
            self.body = result.success
            self.status = 200
          else
            # error = result.failure.try(:messages) || result.failure.try(:message) || result.failure
            self.body = { data: errors_messages(result) }.to_json
            self.status = 400
          end
        end

      end
    end
  end
end
