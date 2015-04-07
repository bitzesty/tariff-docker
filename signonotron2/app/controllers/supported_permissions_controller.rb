class SupportedPermissionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_and_authorize_application
  respond_to :html

  def new
    @supported_permission = @application.supported_permissions.build
  end

  def edit
    @supported_permission = SupportedPermission.find(params[:id])
  end

  def create
    @supported_permission = @application.supported_permissions.build(supported_permission_parameters)
    if @supported_permission.save
      redirect_to doorkeeper_application_supported_permissions_path,
        notice: "Successfully added permission #{@supported_permission.name} to #{@application.name}"
    else
      render :new
    end
  end

  def update
    @supported_permission = SupportedPermission.find(params[:id])
    if @supported_permission.update_attributes(supported_permission_parameters)
      redirect_to doorkeeper_application_supported_permissions_path,
        notice: "Successfully updated permission #{@supported_permission.name}"
    else
      render :edit
    end
  end

private

  def load_and_authorize_application
    @application = Doorkeeper::Application.find(params[:doorkeeper_application_id])
    authorize @application, :manage_supported_permissions?
  end

  def supported_permission_parameters
    params[:supported_permission].slice(:name, :delegatable)
  end

end
