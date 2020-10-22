# frozen_string_literal: true

RSpec.describe UsersServices::UpdateUserService do

  describe 'update user' do
    context 'when valid params' do
      let!(:user) { create :user }
      let!(:params) { attributes_for :user_attributes }

      subject { UsersServices::UpdateUserService.new.call({ id: user.id, user: params }) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'user name equal subject name' do
        res = subject
        u = UserRepository.new.find(user.id)
        expect(JSON.parse(res.success)['data']['attributes']['first_name']).to eq u.first_name
        expect(JSON.parse(res.success)['data']['attributes']['last_name']).to eq u.last_name
      end
    end

    context 'when token expired' do
      let!(:user) { create :user }
      let!(:params) { attributes_for :user_attributes }

      subject do
        params[:password] = 'qwerty'
        UsersServices::UpdateUserService.new.call({ id: user.id, user: params })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.messages).to eq confirm_password_at_update: ['user not found or wrong password']
      end
    end
  end
end
