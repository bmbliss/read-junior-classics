class HomeController < ApplicationController
  def index
    @featured_programs = Program.order(created_at: :desc).limit(3)
    @recent_literary_works = LiteraryWork.order(created_at: :desc).limit(5)
  end
end
