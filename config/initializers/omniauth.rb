Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    Rails.application.secrets.omniauth_provider_key,
    Rails.application.secrets.omniauth_provider_secret,
    scope: 'public_repo,write:repo_hook'
end
