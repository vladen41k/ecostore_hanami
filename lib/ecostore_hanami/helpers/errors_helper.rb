# frozen_string_literal: true

module Helpers
  module ErrorsHelper

    def errors_messages(result)
      result.failure.try(:messages) || result.failure.try(:message) || result.failure
    end

  end
end

