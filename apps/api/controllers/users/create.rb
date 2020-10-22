module Api
  module Controllers
    module Users
      class Create
        include Api::Action
        include Helpers::ErrorsHelper

        def call(params)
          result = UsersServices::CreateUserService.new.call(params)
          if result.success?
            self.body = result.success
            self.status = 201
          else
            self.body = { data: errors_messages(result) }.to_json
            self.status = 400
          end
        end

      end
    end
  end
end
