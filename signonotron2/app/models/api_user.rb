class ApiUser < User
  default_scope where(api_user: true).order(:name)

  DEFAULT_TOKEN_LIFE = 10.years.to_i
end
