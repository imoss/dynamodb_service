module CommentsHelpers
  def comment
    @comment ||= id ? Comment.find({id: id}) : Comment.new(attrs)
  end

  def attrs
    request_body[:comment]
  end

  def id
    params[:id]
  end
end
