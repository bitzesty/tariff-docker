# We conditionally apply the model enhancements (at the time of writing, only one exists) since the model change
# was breaking a migration when spinning up a clean install.
#
# ==  SwapMagicEverythingPermissionsForRealOnes: migrating ======================
# rake aborted!
# An error has occurred, all later migrations canceled:
#
# Mysql2::Error: Table 'signonotron2_development.supported_permissions' doesn't exist: SHOW FIELDS FROM `supported_permissions`
#
unless ( File.basename($0) == "rake" && ARGV.include?("db:migrate") )
  Dir[Rails.root.join("app", "models", "enhancements", "*.rb")].each do |path|
    name = File.basename(path, ".rb")
    require "enhancements/#{name}"
  end
end