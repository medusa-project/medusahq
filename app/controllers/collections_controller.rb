class CollectionsController < ApplicationController

  DEFAULT_WINDOW_SIZE = 100

  ##
  # Responds to GET /collections
  #
  def index
    @start = params[:start]&.to_i || 0
    @limit = params[:limit]&.to_i || DEFAULT_WINDOW_SIZE

    @collections = Collection.order(:title)
    @count       = @collections.count
    @collections = @collections.
        offset(@start).
        limit(@limit)
  end

  ##
  # Responds to GET /collections/:repository_id
  #
  def show
    @collection = Collection.find_by_repository_id(params[:repository_id])
  end

end
