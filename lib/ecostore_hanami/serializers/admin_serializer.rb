# frozen_string_literal: true

class AdminSerializer
  include JSONAPI::Serializer
  attributes :full_name, :email, :activated
end
