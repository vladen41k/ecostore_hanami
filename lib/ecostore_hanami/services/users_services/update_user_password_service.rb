# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module UsersServices
  class UpdateUserPasswordService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield update_user_password(valid_params[:id], valid_params[:user])

      Success(result)
    end

    private

    def validate(params)
      res = UpdateUserPasswordValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def update_user_password(id, user_params)
      Try do
        password_digest = BCrypt::Password.create(user_params[:new_password])
        user = UserRepository.new.update(id, password_digest: password_digest)

        UserSerializer.new(user).serializable_hash.to_json
      end.to_result
    end
  end
end
