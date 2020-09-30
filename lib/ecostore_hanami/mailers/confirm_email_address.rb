module Mailers
  class ConfirmEmailAddress
    include Hanami::Mailer
    include Hanami::Helpers::LinkToHelper

    from    'ecostore@ecostore.com'
    to      :user_email
    subject 'Confirm email to Ecostore'

    private

    def user_email
      user.email
    end

  end
end
