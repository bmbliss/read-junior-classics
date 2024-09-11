class LiteraryWorksController < ApplicationController
  before_action :set_literary_work, only: %i[ show edit update destroy ]

  # GET /literary_works
  def index
    @literary_works = LiteraryWork.all
  end

  # GET /literary_works/1
  def show
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

  # DELETE /literary_works/1
  def destroy
    @literary_work.destroy!
    redirect_to literary_works_url, notice: "Literary work was successfully destroyed.", status: :see_other
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
