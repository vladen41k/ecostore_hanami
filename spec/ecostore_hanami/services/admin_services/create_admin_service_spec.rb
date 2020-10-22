# frozen_string_literal: true

RSpec.describe AdminsServices::CreateAdminService do

  describe 'create new admin' do
    context 'when valid params' do
      let(:admin) { attributes_for :admin_attributes }

      subject { AdminsServices::CreateAdminService.new.call(admin: admin) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is new admin in db' do
        expect { subject }.to change(AdminUserRepository.new.admin_users, :count).by(1)
      end
    end

    context 'when invalid params' do
      let(:admin) { attributes_for :admin_attributes, email: 'qwerty' }

      subject { AdminsServices::CreateAdminService.new.call(admin: admin) }

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is not created admin in db' do
        expect { subject }.to change(AdminUserRepository.new.admin_users, :count).by(0)
      end
    end
  end
end
