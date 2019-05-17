class CollectionsController < ApplicationController

  before_action :get_collection, only: %i(show edit update destroy)

  DEFAULT_WINDOW_SIZE = 100

  ##
  # Responds to GET /collections
  #
  def index
    @per_page = params[:per_page]&.to_i || DEFAULT_WINDOW_SIZE
    @page = params[:page]&.to_i || 1
    @start = (@page - 1) * @per_page

    @count = Collection.count
    @collections = Collection.order(:title).paginate(per_page: @per_page, page: @page)
  end

  ##
  # Responds to GET /collections/:uuid
  #
  def show

  end

  def edit

  end

  def update
    if @collection.update_attributes(allowed_params)
      redirect_to @collection
    else
      render 'edit'
    end
  end

  def new
    @collection = Collection.new
  end

  def create
    @collection = Collection.new(allowed_params)
    if @collection.save
      redirect_to @collection
    else
      render 'new'
    end
  end

  def destroy
    if @collection.destroy
      redirect_to collections_path
    else
      redirect_back alert: 'Unknown error deleting collection.', fallback_location: collections_path
    end
  end

  private

  def get_collection
    @collection = Collection.find_by(uuid: params[:uuid])
  end

  def allowed_params
    params[:collection].permit(:title, :description, :access_url, :physical_collection_url, :external_id,
                               :representative_image_id, :representative_item_id,
                               :private_description, :notes, :contact_email)
  end

end
