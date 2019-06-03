class VirtualRepositoriesController < ApplicationController

  before_action :get_virtual_repository, only: %i(show edit update destroy)

  def index
    @virtual_repositories = VirtualRepository.order(:title).all
  end

  def show

  end

  def edit

  end

  def update
    #Don't allow changing the repository
    params[:virtual_repository].delete(:repository_id) if params[:virtual_repository][:repository_id].present?
    if @virtual_repository.update_attributes(allowed_params)
      redirect_to @virtual_repository
    else
      render 'edit'
    end
  end

  def new
    @virtual_repository = VirtualRepository.new(repository_id: params[:repository_id])
  end

  def create
    @virtual_repository = VirtualRepository.new(allowed_params)
    #We can't set these unti the original object is saved
    collection_ids = params[:virtual_repository].delete(:collection_ids)
    @virtual_repository.transaction do
      @virtual_repository = VirtualRepository.new(allowed_params)
      if @virtual_repository.save
        @virtual_repository.collection_ids = collection_ids
        redirect_to @virtual_repository
      else
        render 'new'
      end
    end
  end

  def destroy
    if @virtual_repository.destroy
      redirect_to @virtual_repository.repository
    else
      raise RuntimeError, 'Unable to destroy virtual repository'
    end
  end

  private

  def get_virtual_repository
    @virtual_repository = VirtualRepository.find(params[:id])
  end

  def allowed_params
    params[:virtual_repository].permit(:title, :repository_id, collection_ids: [])
  end

end