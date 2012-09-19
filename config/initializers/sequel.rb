require 'sequel/extensions/pagination_compat'

# Defaults for sensible migrations
Sequel::MySQL.default_engine = 'InnoDB'
Sequel::MySQL.default_charset = 'utf8'

Sequel::Model.plugin :take
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :tariff_validation_helpers