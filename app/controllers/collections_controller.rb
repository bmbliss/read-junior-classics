class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update]

  def index
    add_breadcrumb "Collections", collections_path
    @collections = Collection.all
  end

  def show
    @collection = Collection.find(params[:id])
    add_breadcrumb "Collections", collections_path
    add_breadcrumb @collection.name
  end

  def new
    @collection = Collection.new
  end

  def edit
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      redirect_to @collection, notice: 'Collection was successfully created.'
    else
      render :new
    end
  end

  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
