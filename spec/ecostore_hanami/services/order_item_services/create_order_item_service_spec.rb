# frozen_string_literal: true

RSpec.describe OrderItemsServices::CreateOrderItemService do
  let!(:user) { create :user }
  let!(:product) { create :product }

  describe 'create new order item' do

    context 'when valid params' do

      context 'when order and order item is absent' do
        subject do
          params = { order_item: { product_id: product.id, quantity: 3 } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is successful' do
          expect(subject).to be_success
        end

        it 'is new order item in db' do
          expect { subject }.to change(OrderItemRepository.new.order_items, :count).by(1)
        end

        it 'is new order in db' do
          expect { subject }.to change(OrderRepository.new.orders, :count).by(1)
        end
      end

      context 'when order is present but order item is absent' do
        before do
          OrderRepository.new.create(user_id: user.id, status: Order.status(:cart))
        end

        subject do
          params = { order_item: { product_id: product.id, quantity: 3 } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is successful' do
          expect(subject).to be_success
        end

        it 'is new order item in db' do
          expect { subject }.to change(OrderItemRepository.new.order_items, :count).by(1)
        end

        it 'order is not create' do
          expect { subject }.to change(OrderRepository.new.orders, :count).by(0)
        end
      end

      context 'when order and order item is present' do
        before do
          order = OrderRepository.new.create(user_id: user.id, status: Order.status(:cart),
                                             total_cost: (product.cost * 9))
          OrderItemRepository.new.create(product_id: product.id, order_id: order.id,
                                         quantity: 9, cost: product.cost, total_cost: (product.cost * 9),
                                         name: product.name)
        end

        subject do
          params = { order_item: { product_id: product.id, quantity: 3 } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is successful' do
          expect(subject).to be_success
        end

        it 'order item updated' do
          subject
          order_item = OrderItemRepository.new.order_items.where(product_id: product.id).one
          expect(order_item.quantity).to eq 12
          expect(order_item.total_cost).to eq product.cost * 12
        end

        it 'order item is not create' do
          expect { subject }.to change(OrderItemRepository.new.order_items, :count).by(0)
        end

        it 'order is not create' do
          expect { subject }.to change(OrderRepository.new.orders, :count).by(0)
        end
      end
    end

    context 'when invalid params' do

      context 'when non-existent product id' do
        subject do
          params = { order_item: { product_id: 900, quantity: 3 } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is failed' do
          expect(subject).to be_failure
        end

        it 'error message' do
          expect(subject.failure.errors).to eq({ product: ['product not found'] })
        end
      end

      context 'when product id type is not int and quantity is nil' do
        subject do
          params = { order_item: { product_id: 'not int', quantity: nil } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is failed' do
          expect(subject).to be_failure
        end

        it 'is failed' do
          expect(subject.failure.errors).to eq({ order_item: { product_id: ['must be an integer'],
                                                               quantity: ['must be filled'] } })
        end
      end

      context 'when quantity type is not int and product id is nil' do
        subject do
          params = { order_item: { product_id: nil, quantity: 'not int' } }
          OrderItemsServices::CreateOrderItemService.new.call(params, user)
        end

        it 'is failed' do
          expect(subject).to be_failure
        end

        it 'is failed' do
          expect(subject.failure.errors).to eq({ order_item: { product_id: ['must be filled'],
                                                               quantity: ['must be an integer'] } })
        end
      end
    end
  end
end
