# frozen_string_literal: true

RSpec.describe UsersServices::CreateUserSessionService do

  describe 'create new user session' do
    let!(:user_params) { attributes_for :user_attributes, activated: true }
    let!(:user) { UsersServices::CreateUserService.new.call(user: user_params) }

    context 'when valid params' do
      subject do
        UsersServices::CreateUserSessionService.new.call(user: { email: user_params[:email],
                                                                 password: user_params[:password] })
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is id in token equal user id' do
        t = JSON.parse(subject.success)['jwt_token']
        arr = JWT.decode t, ENV['API_SESSIONS_SECRET'], true, { algorithm: 'HS256' }

        expect(arr[0]['user_id']).to eq JSON.parse(user.success)['data']['id'].to_i
      end
    end

    context 'when email is absent' do
      subject do
        UsersServices::CreateUserSessionService.new.call(user: { email: '',
                                                                 password: user_params[:password] })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.errors).to eq({ user: { email: ['must be filled'] } })
      end
    end

    context 'when password is absent' do
      subject do
        UsersServices::CreateUserSessionService.new.call(user: { email: user_params[:email],
                                                                 password: '' })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.errors).to eq({ user: { password: ['must be filled'] } })
      end
    end

    context 'when wrong password' do
      subject do
        UsersServices::CreateUserSessionService.new.call(user: { email: user_params[:email],
                                                                 password: 'wrong_password' })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure).to eq({ user: 'email or password is incorrect' })
      end
    end

    context 'when wrong email' do
      subject do
        UsersServices::CreateUserSessionService.new.call(user: { email: 'wrong@email.com',
                                                                 password: user_params[:password] })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure).to eq({ user: 'email or password is incorrect' })
      end
    end
  end
end
