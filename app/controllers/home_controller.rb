class HomeController < ApplicationController
  def index
    @featured_programs = Program.order(created_at: :desc).limit(3)
    @recent_literary_works = LiteraryWork.order(created_at: :desc).limit(5)

    # Test flash messages
    # flash.now[:notice] = "This is a notice message"
    # flash.now[:success] = "This is a success message"
    # flash.now[:error] = "This is an error message"
    # flash.now[:alert] = "This is an alert message"
  end
end
