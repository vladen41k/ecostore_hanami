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
            status 400, { data: params.errors }.to_json
          end
        end

        def activate_user(token)
          repository = UserRepository.new
          user = repository.users.where(activation_digest: token).one

          if user.present?
            params = { activated: true, activation_digest: nil }
            params.merge(activated_at: Time.now) if user.activated_at.blank?
            params.merge(email: user.unconfirmed_email, unconfirmed_email: nil) if user.user.unconfirmed_email.present?

            repository.update(user.id, params)
          end
        end
      end
    end
  end
end
