class RepositoriesController < ApplicationController

  before_action :get_repository, only: %i(show edit update destroy)

  DEFAULT_WINDOW_SIZE = 100

  ##
  # Responds to GET /repositories
  #
  def index
    @per_page = params[:per_page]&.to_i || DEFAULT_WINDOW_SIZE
    @page = params[:page]&.to_i || 1
    @start = (@page - 1) * @per_page

    @count = Repository.count
    @repositories = Repository.order(:title).paginate(per_page: @per_page, page: @page)
  end

  ##
  # Responds to GET /repositories/:uuid
  #
  def show

  end

  def edit

  end

  def update
    if @repository.update_attributes(allowed_params)
      redirect_to @repository
    else
      render 'edit'
    end
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(allowed_params)
    if @repository.save
      redirect_to @repository
    else
      render 'new'
    end
  end

  def destroy
    if @repository.destroy
      redirect_to repositories_path
    else
      redirect_back alert: 'Unknown error deleting repository.', fallback_location: repositories_path
    end
  end

  private

  def get_repository
    @repository = Repostiory.find_by(uuid: params[:uuid])
  end

  def allowed_params
    params[:repository].permit(:title, :url, :notes, :address_1, :address_2, :city, :state, :zip,
                               :phone_number, :email, :contact_email)
  end

end