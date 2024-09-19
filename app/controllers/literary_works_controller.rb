class LiteraryWorksController < ApplicationController
  include Pagy::Backend

  before_action :set_literary_work, only: %i[ edit update ]

  # GET /literary_works
  def index
    add_breadcrumb "Literary Works", literary_works_path
    @pagy, @literary_works = pagy(LiteraryWork.order(:title))
  end

  # GET /literary_works/1
  def show
    @literary_work = LiteraryWork.includes(:collections, :programs, :reading_entries).find(params[:id])
    add_breadcrumb "Literary Works", literary_works_path
    add_breadcrumb @literary_work.title
    @average_rating = @literary_work.average_rating
    @total_ratings = @literary_work.total_ratings
  end

  # GET /literary_works/new
  def new
    @literary_work = LiteraryWork.new
  end

  # GET /literary_works/1/edit
  def edit
  end

  # POST /literary_works
  def create
    @literary_work = LiteraryWork.new(literary_work_params)

    if @literary_work.save
      redirect_to @literary_work, notice: "Literary work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /literary_works/1
  def update
    if @literary_work.update(literary_work_params)
      redirect_to @literary_work, notice: "Literary work was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_literary_work
      @literary_work = LiteraryWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def literary_work_params
      params.require(:literary_work).permit(:title, :author, :work_type, :description, :volume, :page)
    end
end
