# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AdminsServices
  class AuthenticationAdminService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      arr = yield decode_token(valid_params[:jwt_admin_token])
      result = yield find_admin(arr[0]['admin_id'])

      Success(result)
    end

    private

    def validate(params)
      res = AdminAuthJwtTokenValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def decode_token(jwt_token)
      Try do
        hmac_secret = ENV['API_SESSIONS_SECRET']

        JWT.decode jwt_token, hmac_secret, true, { algorithm: 'HS256' }
      end.to_result
    end

    def find_admin(id)
      admin = AdminUserRepository.new.admin_users.where(id: id, activated: true).one

      admin.nil? ? Failure({ admin: 'admin not found' }) : Success(admin)
    end
  end
end
