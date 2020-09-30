module Api
  module Controllers
    module Users
      class ConfirmEmail
        include Api::Action

        params do
          required(:token).filled(:str?)
        end

        def call(params)
          if params.valid?
            user = activate_user(params[:token])

            status 400, { data: { user: 'user not find' } }.to_json && return if user.nil?

            status 200, { data: { user: 'user be activated' } }.to_json
          else
            status 400, params.errors.to_json
          end
        end

        def activate_user(token)
          repository = UserRepository.new
          user = repository.users.where(activation_digest: token).one
          repository.update(user.id, activated: true, activated_at: Time.now, activation_digest: nil) if user.present?
        end
      end
    end
  end
end
