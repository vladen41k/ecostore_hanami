# frozen_string_literal: true

RSpec.describe AdminsServices::CreateAdminSessionService do

  describe 'create new admin session' do
    let!(:admin_params) { attributes_for :admin_attributes }
    let!(:admin) { create :admin }

    context 'when valid params' do
      subject do
        AdminsServices::CreateAdminSessionService.new.call(admin: { email: admin.email,
                                                                    password: admin_params[:password] })
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is id in token equal admin id' do
        t = JSON.parse(subject.success)['jwt_admin_token']
        arr = JWT.decode t, ENV['API_SESSIONS_SECRET'], true, { algorithm: 'HS256' }

        expect(arr[0]['admin_id']).to eq admin.id
      end
    end

    context 'when email is absent' do
      subject do
        AdminsServices::CreateAdminSessionService.new.call(admin: { email: nil,
                                                                    password: admin_params[:password] })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.errors).to eq({ admin: { email: ['must be filled'] } })
      end
    end

    context 'when password is absent' do
      subject do
        AdminsServices::CreateAdminSessionService.new.call(admin: { email: admin.email,
                                                                    password: nil })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.errors).to eq({ admin: { password: ['must be filled'] } })
      end
    end

    context 'when wrong password' do
      subject do
        AdminsServices::CreateAdminSessionService.new.call(admin: { email: admin.email,
                                                                    password: 'wrong_password' })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure).to eq({ admin: 'email or password is incorrect' })
      end
    end

    context 'when wrong email' do
      subject do
        AdminsServices::CreateAdminSessionService.new.call(admin: { email: 'wrong@email.com',
                                                                    password: admin_params[:password] })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure).to eq({ admin: 'email or password is incorrect' })
      end
    end
  end
end
