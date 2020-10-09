# frozen_string_literal: true

RSpec.describe UsersServices::CreateUserService do

  describe 'create new user' do
    context 'when valid params' do
      let(:user) { attributes_for :user_attributes }

      subject { UsersServices::CreateUserService.new.call(user: user) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is new user in db' do
        expect { subject }.to change(UserRepository.new.users, :count).by(1)
      end
    end

    context 'when invalid params' do
      let(:user) { attributes_for :user_attributes, email: 'qwerty' }

      subject { UsersServices::CreateUserService.new.call(user: user) }

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is not created user in db' do
        expect { subject }.to change(UserRepository.new.users, :count).by(0)
      end
    end
  end
end
