require 'dry/monads'
require 'dry/monads/do'
require 'securerandom'

module UsersServices
  class CreateUserService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield create_user(valid_params[:user])

      Success(result)
    end

    private

    def validate(params)
      res = CreateUserValidation.new(params).validate
      if res.success?
        res[:user][:email] = res[:user][:email].downcase

        Success(res)
      else
        Failure(res)
      end
    end

    def create_user(user_params)
      Try do
        user_params[:password_digest] = BCrypt::Password.create(user_params[:password])
        user_params[:activation_digest] = SecureRandom.hex
        user = UserRepository.new.create(user_params)
        Mailers::ConfirmEmailAddress.deliver(user: user)

        UserSerializer.new(user).serializable_hash.to_json
      end.to_result
    end
  end
end
