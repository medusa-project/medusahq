class VirtualRepositoriesController < ApplicationController

  def index
    @virtual_repositories = VirtualRepository.order(:title).all
  end

end