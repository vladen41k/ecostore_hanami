module Api
  module Controllers
    module Users
      class Create
        include Api::Action

        def call(params)
          result = UsersServices::CreateUserService.new.call(params)
          if result.success?
            self.body = result.success
            self.status = 201
          else
            self.body = { data: result.failure.errors }.to_json
            self.status = 400
          end
        end

      end
    end
  end
end
