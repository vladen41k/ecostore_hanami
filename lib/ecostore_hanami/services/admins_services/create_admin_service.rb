# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AdminsServices
  class CreateAdminService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield create_admin(valid_params[:admin])

      Success(result)
    end

    private

    def validate(params)
      res = CreateAdminValidation.new(params).validate
      if res.success?
        res[:admin][:email] = res[:admin][:email].downcase

        Success(res)
      else
        Failure(res)
      end
    end

    def create_admin(admin_params)
      Try do
        admin_params[:password_digest] = BCrypt::Password.create(admin_params[:password])
        admin = AdminUserRepository.new.create(admin_params)

        AdminSerializer.new(admin).serializable_hash.to_json
      end.to_result
    end
  end
end
