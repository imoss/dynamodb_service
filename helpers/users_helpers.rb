module UsersHelpers
  def user
    @user ||= id ? User.find({id: id}) : User.new(attrs)
  end

  def attrs
    request_body[:user]
  end

  def id
    params[:id]
  end
end
