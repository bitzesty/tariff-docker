class DoorkeeperApplicationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_and_authorize_application, except: :index

  respond_to :html

  def index
    authorize Doorkeeper::Application
    @applications = Doorkeeper::Application.all
  end

  def update
    if @application.update_attributes(doorkeeper_application_params)
      redirect_to doorkeeper_applications_path, notice: "Successfully updated #{@application.name}"
    else
      respond_with @application
    end
  end

  private

  def load_and_authorize_application
    @application = Doorkeeper::Application.find(params[:id])
    authorize @application
  end

  def doorkeeper_application_params
    # Since our Pundit policies ensure that only a superadmin can access this
    # controller, we can whitelist all attributes the edit form can modify
    params.require(:doorkeeper_application).permit(
      :name,
      :description,
      :uid,
      :secret,
      :redirect_uri,
      :home_uri,
      :supports_push_updates,
    )
  end
end
