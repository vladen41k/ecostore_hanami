class UserRepository < Hanami::Repository
  associations do
    has_many :orders
  end

  def all_where(hash)
    users.where(hash).to_a
  end

end
