module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :add_breadcrumb, :breadcrumbs
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  class Breadcrumb < Struct.new(:name, :path)
  end
end
