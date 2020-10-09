# frozen_string_literal: true

RSpec.describe OrderItemsServices::DeleteOrderItemService do
  let!(:user) { create :user }
  let!(:product) { create :product }
  let!(:order) { create :order, user_id: user.id, total_cost: (product.cost * 7) }
  let!(:order_item) do
    order_items_params = { product_id: product.id, order_id: order.id,
                           cost: product.cost, total_cost: (product.cost * 7),
                           quantity: 7 }
    create :order_item, order_items_params
  end

  describe 'delete order item' do

    context 'when valid params' do

      context 'when delete all order item' do
        subject do
          params = { id: order_item.id, order_item: { quantity: 7 } }
          OrderItemsServices::DeleteOrderItemService.new.call(params, user)
        end

        it 'is successful' do
          expect(subject).to be_success
        end

        it 'order be delete' do
          expect { subject }.to change(OrderItemRepository.new.order_items, :count).by(-1)
        end
      end

      context 'when partially delete order item' do
        before do
          OrderRepository.new.create(user_id: user.id, status: Order.status(:cart))
        end

        subject do
          params = { id: order_item.id, order_item: { quantity: 3 } }
          OrderItemsServices::DeleteOrderItemService.new.call(params, user)
        end

        it 'is successful' do
          expect(subject).to be_success
        end

        it 'total cost be update' do
          total_cost = JSON.parse(subject.success)['data']['attributes']['total_cost']
          expect(total_cost).to eq product.cost * 4
        end

        it 'order item not delete' do
          expect { subject }.to change(OrderItemRepository.new.order_items, :count).by(0)
        end
      end
    end

    context 'when invalid params' do

      context 'when non-correct quantity' do
        subject do
          params = { id: order_item.id, order_item: { quantity: 8 } }
          OrderItemsServices::DeleteOrderItemService.new.call(params, user)
        end

        it 'is failed' do
          expect(subject).to be_failure
        end

        it 'error message' do
          expect(subject.failure.message).to eq 'wrong quantity'
        end
      end

      context 'when id is not integer' do
        subject do
          params = { id: 'order_item.id', order_item: { quantity: 7 } }
          OrderItemsServices::DeleteOrderItemService.new.call(params, user)
        end

        it 'is failed' do
          expect(subject).to be_failure
        end

        it 'is failed' do
          expect(subject.failure.errors).to eq({ id: ['must be an integer'] })
        end
      end
    end
  end
end
