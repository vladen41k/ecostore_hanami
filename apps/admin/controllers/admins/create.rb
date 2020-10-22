# frozen_string_literal: true

require_relative '../authenticate_admin_helper'

module Admin
  module Controllers
    module Admins
      class Create
        include Admin::Action
        include Helpers::ErrorsHelper
        include AuthenticateAdminHelper

        def call(params)
          if current_admin
            result = AdminsServices::CreateAdminService.new.call(params)

            result.success? ? status(201, result.success) : status(400, { data: errors_messages(result) }.to_json)
          else
            # status 400, { data: { admin: 'must be authenticated' } }.to_json
            status 400, { data: current_admin_errors }.to_json
          end
        end
      end
    end
  end
end
