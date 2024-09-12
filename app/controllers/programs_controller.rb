class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update ]

  # GET /programs
  def index
    @programs = Program.all
  end

  # GET /programs/1
  def show
    @program_items = @program.program_items.includes(:literary_work).order('literary_works.title')
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  def create
    @program = Program.new(program_params)

    if @program.save
      redirect_to @program, notice: "Program was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /programs/1
  def update
    if @program.update(program_params)
      redirect_to @program, notice: "Program was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:name, :recommended_grade, :description)
    end
end
