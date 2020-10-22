# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module UsersServices
  class UpdateUserService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params, by_admin = false)
      valid_params = yield validate(params, by_admin)
      result = yield update_user(valid_params[:id], valid_params[:user])

      Success(result)
    end

    private

    def validate(params, by_admin)
      res = if by_admin
              UpdateUserByAdminValidation.new(params).validate
            else
              UpdateUserValidation.new(params).validate
            end

      res.success? ? Success(res) : Failure(res)
    end

    def update_user(id, user_params)
      Try do
        user_params.delete(:password)
        user = if user_params[:email].present?
                 user_params[:unconfirmed_email] = user_params.delete(:email)
                 user_params[:activation_digest] = SecureRandom.hex
                 user = UserRepository.new.update(id, user_params)
                 Mailers::ConfirmEmailAddress.deliver(user: user)

                 user
               else
                 UserRepository.new.update(id, user_params)
               end

        UserSerializer.new(user).serializable_hash.to_json
      end.to_result
    end
  end
end
