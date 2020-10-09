# frozen_string_literal: true

# require 'spec_helper'

RSpec.describe Api::Controllers::Products::Create, type: :action do
  # let(:action) { described_class.new }
  let!(:params) { attributes_for :product }
  # let!(:params2) { Fabricate.create(:book, review: Fabricate.create(:review)) }


  describe 'create' do
    context 'when valid params' do


      it 'is successful' do
        byebug
        response = action.call(params)
        expect(response[0]).to eq 200
      end
    end
  end
end
