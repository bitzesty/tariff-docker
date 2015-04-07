namespace :docker do
  desc "Ensures tariff applications are setup"
  task tariff_applications: :environment do
    apps = [
      {
        name: "trade-tariff-admin",
        description: "trade-tariff-admin",
        home_uri: "http://tariff-admin.dev.gov.uk",
        redirect_uri: "http://tariff-admin.dev.gov.uk/auth/gds/callback"
      },
      {
        name: "trade-tariff-backend",
        description: "trade-tariff-backend",
        home_uri: "http://tariff-api.dev.gov.uk",
        redirect_uri: "http://tariff-api.dev.gov.uk/auth/gds/callback"
      }
    ]
    apps.each do |app|
      Doorkeeper::Application.where(name: app[:name])
                             .first_or_create.tap do |record|
                               record.update_attributes(app)
                             end
    end
  end
end
