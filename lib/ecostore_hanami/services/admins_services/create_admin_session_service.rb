# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AdminsServices
  class CreateAdminSessionService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    INCORRECT_EMAIL = 'email or password is incorrect'

    def call(params)
      valid_params = yield validate(params)
      admin = yield find_admin(valid_params[:admin])
      result = yield create_admin_session(admin)

      Success(result)
    end

    private

    def validate(params)
      res = CreateAdminSessionValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def find_admin(params)
      admin = AdminUserRepository.new.admin_users.where(email: params[:email], activated: true).one

      if admin.nil?
        Failure({ admin: INCORRECT_EMAIL })
      elsif BCrypt::Password.new(admin.password_digest) != params[:password]
        Failure({ admin: INCORRECT_EMAIL })
      else
        Success(admin)
      end
    end

    def create_admin_session(admin)
      Try do
        hmac_secret = ENV['API_SESSIONS_SECRET']
        payload = { admin_id: admin.id, exp: Time.now.to_i + 12 * 3600 }
        token = JWT.encode payload, hmac_secret, 'HS256'
        AdminUserRepository.new.update(admin.id, current_sign_in_at: Time.now, last_sign_in_at: admin.current_sign_in_at)

        { jwt_admin_token: token }.to_json
      end.to_result
    end
  end
end
