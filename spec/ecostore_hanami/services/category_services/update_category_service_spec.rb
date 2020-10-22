# frozen_string_literal: true

RSpec.describe ProductsServices::UpdateProductService do
  let!(:category) { create :category }
  let!(:params) { attributes_for :category }

  describe 'update category' do
    context 'when valid params' do

      subject do
        new_params = { id: category.id, category: params }
        CategoriesServices::UpdateCategoryService.new.call(new_params)
      end

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'is return json' do
        expect(subject.success).to eq CategorySerializer.new(CategoryRepository.new
                                                                .find(category.id))
                                          .serializable_hash.to_json
      end
    end

    context 'when invalid params' do

      subject do
        new_params = { id: category.id, category: { name: '' } }
        CategoriesServices::UpdateCategoryService.new.call(new_params)
      end

      it 'is failed' do
        expect(subject).to be_failure
      end

      it 'is return error message' do
        error_message = { category: { name: ['must be filled'] } }

        expect(subject.failure.errors).to eq error_message
      end
    end
  end
end
