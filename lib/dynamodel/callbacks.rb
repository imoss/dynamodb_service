module Dynamodel
  module Callbacks
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      define_callbacks :save
      set_callback :save, :after, :after_save
      set_callback :save, :before, :before_save
    end

    def after_save; end
    def before_save; end
  end
end
