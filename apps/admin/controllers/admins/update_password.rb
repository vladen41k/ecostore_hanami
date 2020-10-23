# frozen_string_literal: true

require_relative '../authenticate_admin_helper'

module Admin
  module Controllers
    module Admins
      class UpdatePassword
        include Admin::Action
        include Helpers::ErrorsHelper
        include AuthenticateAdminHelper

        def call(params)
          if current_admin
            result = AdminsServices::UpdateAdminService.new.call(params)

            result.success? ? status(200, result.success) : status(400, { data: errors_messages(result) }.to_json)
          else
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end
