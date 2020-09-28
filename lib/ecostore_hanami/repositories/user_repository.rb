class UserRepository < Hanami::Repository

  def all_where(hash)
    users.where(hash).to_a
  end

end
