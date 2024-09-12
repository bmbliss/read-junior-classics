class ReadingEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reading_entry, only: [:show, :edit, :update, :destroy]

  # GET /reading_entries
  def index
    @reading_entries = current_user.reading_entries
  end

  # GET /reading_entries/1
  def show
  end

  # GET /reading_entries/new
  def new
    @program_enrollment = current_user.program_enrollments.find(params[:program_enrollment_id])
    @reading_entry = @program_enrollment.reading_entries.new
  end

  # GET /reading_entries/1/edit
  def edit
  end

  # POST /reading_entries
  def create
    @program_enrollment = current_user.program_enrollments.find(params[:reading_entry][:program_enrollment_id])
    @reading_entry = @program_enrollment.reading_entries.new(reading_entry_params)

    if @reading_entry.save
      redirect_to @program_enrollment.child, notice: 'Reading entry was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /reading_entries/1
  def update
    if @reading_entry.update(reading_entry_params)
      redirect_to @reading_entry, notice: "Reading entry was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reading_entries/1
  def destroy
    @reading_entry.destroy!
    redirect_to reading_entries_url, notice: "Reading entry was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reading_entry
      @reading_entry = current_user.reading_entries.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reading_entry_params
      params.require(:reading_entry).permit(:literary_work_id, :status, :date_read, :rating, :notes)
    end
end
