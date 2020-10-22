# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AdminsServices
  class UpdateAdminService
    include Dry::Monads[:result, :try]
    include Dry::Monads::Do.for(:call)

    def call(params)
      valid_params = yield validate(params)
      result = yield update_admin(valid_params[:id], valid_params[:admin])

      Success(result)
    end

    private

    def validate(params)
      res = UpdateAdminValidation.new(params).validate

      res.success? ? Success(res) : Failure(res)
    end

    def update_admin(id, params)
      Try do
        admin = AdminUserRepository.new.update(id, params)

        AdminSerializer.new(admin).serializable_hash.to_json
      end.to_result
    end
  end
end
