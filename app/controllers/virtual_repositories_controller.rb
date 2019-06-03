class VirtualRepositoriesController < ApplicationController

  before_action :get_virtual_repository, only: %i(show edit update destroy)

  def index
    @virtual_repositories = VirtualRepository.order(:title).all
  end

  def show

  end

  private

  def get_virtual_repository
    @virtual_repository = VirtualRepository.find(params[:id])
  end

end