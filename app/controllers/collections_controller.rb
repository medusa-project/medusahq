class CollectionsController < ApplicationController

  before_action :get_collection, only: %i(show edit update)

  DEFAULT_WINDOW_SIZE = 100

  ##
  # Responds to GET /collections
  #
  def index
    @start = params[:start]&.to_i || 0
    @limit = params[:limit]&.to_i || DEFAULT_WINDOW_SIZE

    @collections = Collection.order(:title)
    @count = @collections.count
    @collections = @collections.
        offset(@start).
        limit(@limit)
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

  private

  def get_collection
    @collection = Collection.find_by(uuid: params[:uuid])
  end

  def allowed_params
    params[:collection].permit(:title, :description, :access_url, :physical_collection_url, :external_id,
                               :representative_image_id, :representative_item_id,
                               :private_description, :notes)
  end

end
