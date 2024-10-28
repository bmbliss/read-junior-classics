module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :add_breadcrumb, :breadcrumbs
    before_action :store_path_history
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  private

  def store_path_history
    return if request.xhr? || !request.get?

    session[:path_history] ||= []
    session[:path_history].push(request.path)
    session[:path_history] = session[:path_history].last(3) # Keep last 3 paths
  end

  class Breadcrumb < Struct.new(:name, :path)
  end
end
