class ReadingEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reading_entry, only: [:show, :edit, :update, :destroy]

  # GET /reading_entries
  def index
    @reading_entries = if params[:child_id]
      current_user.children.find(params[:child_id]).reading_entries
    else
      current_user.reading_entries
    end
  end

  # GET /reading_entries/1
  def show
  end

  # GET /reading_entries/new
  def new
    @literary_work = LiteraryWork.find(params[:literary_work_id])
    @reading_entry = ReadingEntry.new(literary_work: @literary_work)
  end

  # GET /reading_entries/1/edit
  def edit
  end

  # POST /reading_entries
  def create
    @reader = find_reader
    @reading_entry = @reader.reading_entries.new(reading_entry_params)
    @reading_entry.date_read ||= Date.today
    
    if @reading_entry.save
      respond_to do |format|
        format.html { redirect_to @reading_entry.literary_work, notice: "Reading entry was successfully created." }
        format.json { render json: reading_entry_json }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @reading_entry.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reading_entries/1
  def update
    if @reading_entry.update(reading_entry_params)
      respond_to do |format|
        format.html { redirect_to @reading_entry, notice: "Reading entry was successfully updated." }
        format.json { render json: reading_entry_json }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @reading_entry.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reading_entries/1
  def destroy
    @reading_entry.destroy!
    redirect_to reading_entries_url, notice: "Reading entry was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reading_entry
      @reading_entry = ReadingEntry.find(params[:id])
      authorize_reading_entry
    end

    def find_reader
      if params[:child_id]
        current_user.children.find(params[:child_id])
      else
        current_user
      end
    end

    def authorize_reading_entry
      unless @reading_entry.reader == current_user || 
             (@reading_entry.reader.is_a?(Child) && @reading_entry.reader.user == current_user)
        raise ActiveRecord::RecordNotFound
      end
    end

    # Only allow a list of trusted parameters through.
    def reading_entry_params
      params.require(:reading_entry).permit(:literary_work_id, :rating, :program_id)
    end

    def reading_entry_json
      {
        status: @reading_entry.status,
        rating: @reading_entry.rating,
        reader: {
          id: @reading_entry.reader_id,
          type: @reading_entry.reader_type,
          name: @reading_entry.reader.respond_to?(:name) ? @reading_entry.reader.name : @reading_entry.reader.email
        }
      }
    end
end
