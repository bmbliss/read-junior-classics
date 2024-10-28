class HomeController < ApplicationController
  def index
    if user_signed_in?
      @children = current_user.children
    end
    
    @featured_programs = Program.order(created_at: :desc).limit(5)
    @recent_literary_works = LiteraryWork.order(created_at: :desc).limit(5)
    @collections = Collection.order(created_at: :desc).limit(3)
  end
end
