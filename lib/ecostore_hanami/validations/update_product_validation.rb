class UpdateProductValidation
  include Hanami::Validations

  messages_path 'config/errors.yml'

  validations do
    required(:id).filled(:int?)
    required(:product).schema do
      required(:name).filled(:str?)
      required(:cost).filled(:int?)
      required(:category_ids).filled

      validate(category_ids_exist: %i[category_ids]) do |cat_ids|
        array_ids = cat_ids.tr('^0-9,', '').split(',')
        array_ids.size == CategoryRepository.new.all_where(id: array_ids).size
      end
    end
  end
end
