Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['twitter_id'], ENV['twitter_secret']
  provider :google_oauth2, ENV['google_oauth2_id'], ENV['google_oauth2_secret'], {access_type: 'online', approval_prompt: ''}
  provider :facebook, ENV['facebook_id'], ENV['facebook_secret'], {:client_options => {:ssl => {:verify => false}}} #, :scope => 'email,offline_access,read_stream', :display => 'popup', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
  provider :vkontakte, ENV['vkontakte_id'], ENV['vkontakte_secret'], :display => 'popup'
end
