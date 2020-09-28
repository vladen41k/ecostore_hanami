class AuthJwtTokenValidation
  include Hanami::Validations

  validations do
    required(:jwt_token).filled(:str?)
  end

end
