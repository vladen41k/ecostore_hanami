module Api
  module Controllers
    module Products
      class Update
        include Api::Action

        expose :product

        params do
          required(:id).filled(:int?)
          required(:product).schema do
            optional(:name).filled(:str?)
            optional(:category_ids).filled
          end
        end

        def initialize
          @category_id_not_exist = []
        end

        def call(params)
          if params.valid?
            self.body = if params[:product][:category_ids].present?
                          update_with_category(params[:id], params)
                        else
                          product = ProductRepository.new.update(params[:id], params)

                          ProductSerializer.new(product).serializable_hash.to_json
                        end
            self.status = 200
          else
            self.body = params.errors.to_json
            self.status = 400
          end
        end

        private

        def update_with_category(id, params)
          category_ids = params[:product].delete(:category_ids)
          category_ids.split(',').each { |i| @category_id_not_exist << i if CategoryRepository.new.find(i).nil? }
          if @category_id_not_exist.present?
            { category_ids_does_not_exist: @category_id_not_exist }.to_json
          else
            product = ProductRepository.new.update(id, params)
            ProductRepository.new.update_category(id, category_ids)

            ProductSerializer.new(product).serializable_hash.to_json
          end
        end
      end
    end
  end
end
