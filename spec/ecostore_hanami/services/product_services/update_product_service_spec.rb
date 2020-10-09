# frozen_string_literal: true

RSpec.describe ProductsServices::UpdateProductService do
  let!(:category) { create :category }
  let!(:product) { create :product, :with_category }
  let!(:params) { attributes_for :product }

  describe 'update product' do
    context 'when valid params' do

      subject do
        new_params = { id: product.id, product: params.merge(category_ids: category.id.to_s) }

        ProductsServices::UpdateProductService.new.call(new_params)
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is return json' do
        expect(subject.success).to eq ProductSerializer.new(ProductRepository.new
                                                       .find(product.id))
                                                       .serializable_hash.to_json
      end
    end

    context 'when invalid params' do

      subject do
        new_params = { id: product.id, product: params }
        ProductsServices::UpdateProductService.new.call(new_params)
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is return error message' do
        error_message = { product: { category_ids: ['is missing'] } }

        expect(subject.failure.errors).to eq error_message
      end
    end
  end
end
