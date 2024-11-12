class ReadingEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reading_entry, only: [:show, :edit, :update, :destroy]
  before_action :authorize_reading_entry, only: [:show, :edit, :update, :destroy]

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
    @reading_entry = ReadingEntry.find_or_initialize_by(
      literary_work_id: reading_entry_params[:literary_work_id],
      reader: find_reader_by_id(params[:reading_entry][:reader_id])
    )
    @reading_entry.assign_attributes(reading_entry_params)

    if @reading_entry.save
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to @reading_entry.literary_work }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to @reading_entry.literary_work, alert: @reading_entry.errors.full_messages.join(", ") }
      end
    end
  end

  # PATCH/PUT /reading_entries/1
  def update
    @reading_entry = ReadingEntry.find(params[:id])
    
    if @reading_entry.update(reading_entry_params)
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to @reading_entry.literary_work }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to @reading_entry.literary_work, alert: @reading_entry.errors.full_messages.join(", ") }
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
      params.require(:reading_entry).permit(:literary_work_id, :rating, :reader_id)
    end

    def reading_entry_json
      {
        rating: @reading_entry.rating,
        reader: {
          id: @reading_entry.reader_id,
          type: @reading_entry.reader_type,
          name: @reading_entry.reader.respond_to?(:name) ? @reading_entry.reader.name : @reading_entry.reader.email
        }
      }
    end

    def current_reader
      # This will automatically set reader_type to either "User" or "Child"
      params[:reading_entry][:child_id] && params[:reading_entry][:child_id].to_i > 0 ? Child.find(params[:reading_entry][:child_id]) : current_user
    end

    def find_reader_by_id(reader_id)
      # First try to find a child
      current_user.children.find_by(id: reader_id) || 
      # If no child found and the ID matches current user, return current user
      (reader_id.to_s == current_user.id.to_s ? current_user : nil)
    end
end
