# frozen_string_literal: true

RSpec.describe AdminsServices::AuthenticationAdminService do

  describe 'authenticate admin' do
    let!(:admin) { create :admin }

    context 'when valid params' do
      let!(:jwt) do
        payload = { admin_id: admin.id, exp: Time.now.to_i + 12 * 3600 }
        JWT.encode payload, ENV['API_SESSIONS_SECRET'], 'HS256'
      end

      subject { AdminsServices::AuthenticationAdminService.new.call(jwt_admin_token: jwt) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'admin equal subject' do
        expect(subject.success).to eq admin
      end
    end

    context 'when token expired' do
      let!(:jwt) do
        payload = { admin_id: admin.id, exp: Time.now.to_i }
        JWT.encode payload, ENV['API_SESSIONS_SECRET'], 'HS256'
      end

      subject { AdminsServices::AuthenticationAdminService.new.call(jwt_admin_token: jwt) }

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'admin not equal subject' do
        expect(subject.success).to_not eq admin
      end

      it 'error message' do
        expect(subject.failure.message).to eq 'Signature has expired'
      end
    end
  end
end
