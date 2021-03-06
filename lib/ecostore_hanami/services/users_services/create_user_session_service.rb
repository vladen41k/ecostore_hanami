# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module UsersServices
  class CreateUserSessionService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    INCORRECT_EMAIL = 'email or password is incorrect'

    def call(params)
      valid_params = yield validate(params)
      user = yield find_user(valid_params[:user])
      result = yield create_user_session(user)

      Success(result)
    end

    private

    def validate(params)
      res = CreateUserSessionValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def find_user(params)
      user = UserRepository.new.users.where(email: params[:email], activated: true).one

      if user.nil?
        Failure({ user: INCORRECT_EMAIL })
      elsif BCrypt::Password.new(user.password_digest) != params[:password]
        Failure({ user: INCORRECT_EMAIL })
      else
        Success(user)
      end
    end

    def create_user_session(user)
      Try do
        hmac_secret = ENV['API_SESSIONS_SECRET']
        payload = { user_id: user.id, exp: Time.now.to_i + 12 * 3600 }
        token = JWT.encode payload, hmac_secret, 'HS256'
        UserRepository.new.update(user.id, current_sign_in_at: Time.now, last_sign_in_at: user.current_sign_in_at)

        { jwt_token: token }.to_json
      end.to_result
    end
  end
end
