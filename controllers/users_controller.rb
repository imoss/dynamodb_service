class UsersController < DynamodbService
  helpers ParamsHelpers
  helpers UsersHelpers

  get '/:id' do
    halt 500, "Record Not Found" unless user
    body user.to_json
  end

  delete '/:id' do
    halt 500, "Record Not Found" unless user
    user.destroy
  end

  post '/' do
    user.save
    body user.to_json
  end

  put '/:id' do
    halt 500, "Record Not Found" unless user
    user.update_attributes(request_body[:user])
    body user.to_json
  end
end
