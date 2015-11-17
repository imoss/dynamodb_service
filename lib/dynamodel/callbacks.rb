module Dynamodel
  module Callbacks
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      define_callbacks :save, :destroy
      set_callback :save, :before, :before_save
      set_callback :save, :after, :after_save
      set_callback :destroy, :before, :before_destroy
      set_callback :destroy, :after, :after_destroy
    end

    def before_save; end
    def after_save; end
    def before_destroy; end
    def after_destroy; end
  end
end
