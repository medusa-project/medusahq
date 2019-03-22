require_relative 'config_custom'
Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    opts = Settings.shibboleth
    provider :shibboleth, opts.to_h.symbolize_keys
  else
    provider :developer
  end
end
OmniAuth.config.logger = Rails.logger