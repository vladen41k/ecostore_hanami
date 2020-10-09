# frozen_string_literal: true

RSpec.describe ProductsServices::CreateProductService do
  let!(:category) { create :category }
  let!(:params) { attributes_for :product }

  describe 'create new product' do
    context 'when valid params' do

      subject do
        ProductsServices::CreateProductService.new.call(product: params.merge(category_ids: category.id.to_s))
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is new product in db' do
        expect { subject }.to change(ProductRepository.new.products, :count).by(1)
      end

      it 'is new association to product with category' do
        expect { subject }.to change(CategoryProductsRepository.new.category_products, :count).by(1)
      end
    end

    context 'when invalid params' do

      subject do
        ProductsServices::CreateProductService.new.call(product: params)
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is not created product in db' do
        expect { subject }.to change(ProductRepository.new.products, :count).by(0)
      end

      it 'is not created association to product with category' do
        expect { subject }.to change(CategoryProductsRepository.new.category_products, :count).by(0)
      end
    end
  end
end
