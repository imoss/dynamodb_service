require 'active_support/core_ext/hash/indifferent_access'

module ParamsHelpers
  def request_body
    @body ||= JSON.parse(request.body.read).with_indifferent_access
  end
end
