module Web
  module Controllers
    module Category
      class Index
        include Web::Action

        def call(params)
          self.body = 'OK'
        end
      end
    end
  end
end
