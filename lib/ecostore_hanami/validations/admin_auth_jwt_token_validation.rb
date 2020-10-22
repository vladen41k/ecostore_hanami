class AdminAuthJwtTokenValidation
  include Hanami::Validations

  validations do
    required(:jwt_admin_token).filled(:str?)
  end

end
