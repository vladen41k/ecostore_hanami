# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AdminsServices
  class UpdateAdminPasswordService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield update_admin_password(valid_params[:id], valid_params[:admin])

      Success(result)
    end

    private

    def validate(params)
      res = UpdateAdminPasswordValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def update_admin_password(id, admin_params)
      Try do
        password_digest = BCrypt::Password.create(admin_params[:new_password])
        admin = AdminUserRepository.new.update(id, password_digest: password_digest)

        AdminSerializer.new(admin).serializable_hash.to_json
      end.to_result
    end
  end
end
