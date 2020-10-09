# frozen_string_literal: true

RSpec.describe UsersServices::AuthenticationUserService do

  describe 'create new user' do
    context 'when valid params' do
      let!(:user) { create :user }
      let!(:jwt) do
        payload = { user_id: user.id, exp: Time.now.to_i + 12 * 3600 }
        JWT.encode payload, ENV['API_SESSIONS_SECRET'], 'HS256'
      end

      subject { UsersServices::AuthenticationUserService.new.call(jwt_token: jwt) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'user equal subject' do
        expect(subject.success).to eq user
      end
    end

    context 'when token expired' do
      let!(:user) { create :user }
      let!(:jwt) do
        payload = { user_id: user.id, exp: Time.now.to_i }
        JWT.encode payload, ENV['API_SESSIONS_SECRET'], 'HS256'
      end

      subject { UsersServices::AuthenticationUserService.new.call(jwt_token: jwt) }

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'user not equal subject' do
        expect(subject.success).to_not eq user
      end

      it 'error message' do
        expect(subject.failure.message).to eq 'Signature has expired'
      end
    end
  end
end
