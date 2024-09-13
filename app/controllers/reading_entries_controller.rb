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
    @program_enrollment = current_user.program_enrollments.find(params[:program_enrollment_id])
    @reading_entry = @program_enrollment.reading_entries.find_or_initialize_by(literary_work_id: reading_entry_params[:literary_work_id])
    @reading_entry.date_read = Date.today if @reading_entry.new_record?
    
    if @reading_entry.update(reading_entry_params)
      render json: { status: @reading_entry.status, rating: @reading_entry.rating, notes: @reading_entry.notes, progress_percentage: @program_enrollment.progress_percentage }
    else
      render json: { errors: @reading_entry.errors.full_messages }, status: :unprocessable_entity
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
      params.require(:reading_entry).permit(:literary_work_id, :status, :rating, :notes)
    end
end
