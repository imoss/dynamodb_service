class CommentsController < DynamodbService
  helpers ParamsHelpers
  helpers CommentsHelpers

  get '/:id' do
    halt 500, "Record Not Found" unless comment
    body comment.to_json
  end

  delete '/:id' do
    halt 500, "Record Not Found" unless comment
    comment.destroy
  end

  post '/' do
    comment.save
    body comment.to_json
  end

  put '/:id' do
    halt 500, "Record Not Found" unless comment
    comment.update_attributes(request_body[:comment])
    body comment.to_json
  end
end
