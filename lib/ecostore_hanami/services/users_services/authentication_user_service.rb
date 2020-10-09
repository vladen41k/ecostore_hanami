# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module UsersServices
  class AuthenticationUserService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      arr = yield decode_token(valid_params[:jwt_token])
      result = yield find_user(arr[0]['user_id'])

      Success(result)
    end

    private

    def validate(params)
      res = AuthJwtTokenValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def decode_token(jwt_token)
      Try do
        hmac_secret = ENV['API_SESSIONS_SECRET']

        JWT.decode jwt_token, hmac_secret, true, { algorithm: 'HS256' }
      end.to_result
    end

    def find_user(id)
      user = UserRepository.new.users.where(id: id, activated: true).one

      user.nil? ? Failure({ user: 'user not found' }) : Success(user)
    end
  end
end
