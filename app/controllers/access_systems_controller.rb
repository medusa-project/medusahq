class AccessSystemsController < ApplicationController

  before_action :get_access_system, only: %i(show edit update destroy collections)

  def index
    @access_systems = AccessSystem.all.order(:name)
  end

  def show

  end

  def new
    @access_system = AccessSystem.new
  end

  def create
    @access_system = AccessSystem.new(allowed_params)
    if @access_system.save
      redirect_to @access_system
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @access_system.update_attributes(allowed_params)
      redirect_to @access_system
    else
      render 'edit'
    end
  end

  def destroy
    if @access_system.destroy
      redirect_to access_systems_path
    else
      redirect_back alert: 'Unknown error deleting access system.', fallback_location: access_systems_path
    end
  end

  def collections
    @per_page = params[:per_page]&.to_i || 100
    @page = params[:page]&.to_i || 1

    @collections = @access_system.collections.order(:title).paginate(per_page: @per_page, page: @page).includes(:repository)
  end

  protected

  def allowed_params
    params[:access_system].permit(:name, :service_owner, :application_manager)
  end

  def get_access_system
    @access_system = AccessSystem.find(params[:id])
  end

end