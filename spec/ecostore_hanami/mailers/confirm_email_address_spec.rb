RSpec.describe Mailers::ConfirmEmailAddress, type: :mailer do
  it 'delivers email' do
    mail = Mailers::ConfirmEmailAddress.deliver
  end
end
