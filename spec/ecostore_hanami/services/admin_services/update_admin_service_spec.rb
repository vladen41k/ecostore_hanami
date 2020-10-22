# frozen_string_literal: true

RSpec.describe AdminsServices::UpdateAdminService do

  describe 'update admin' do
    let!(:admin) { create :admin }
    let!(:params) { attributes_for :admin_attributes }

    context 'when valid params' do
      subject { AdminsServices::UpdateAdminService.new.call({ id: admin.id, admin: params }) }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'user name equal subject name' do
        res = subject
        a = AdminUserRepository.new.find(admin.id)
        expect(JSON.parse(res.success)['data']['attributes']['full_name']).to eq a.full_name
      end
    end

    context 'when token expired' do
      subject do
        params[:email] = 'qwerty'
        AdminsServices::UpdateAdminService.new.call({ id: admin.id, admin: params })
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'error message' do
        expect(subject.failure.messages).to eq admin: { email: ['is in invalid format'] }
      end
    end
  end
end
