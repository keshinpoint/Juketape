class Instagram
  attr_accessor :client_id, :client_secret, :redirect_uri, :access_token
  def initialize(options={})
    @client_id = ENV['INSTAGRAM_CLIENT_ID']
    @client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
    @redirect_uri = options[:redirect_uri]
    @access_token = options[:access_token]
  end

  def oauth_url(options)
    "https://api.instagram.com/oauth/authorize/?client_id=#{client_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=#{options[:scope]}"
  end

  def base_connection
    conn = Faraday.new(url: 'https://api.instagram.com', ssl: {verify: false}) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_access_token(code)
    result = base_connection.post('/oauth/access_token', {
      code: code,
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: redirect_uri,
      grant_type: 'authorization_code'
    })
    result_body = JSON.parse(result.body)
    result_body['access_token']
  end

  def get_user
    result = base_connection.get('/v1/users/self', { access_token: access_token })
    JSON.parse(result.body)['data']
  end

  def recent_images
    result = base_connection.get("/v1/users/#{get_user['id']}/media/recent", {access_token: access_token})
    JSON.parse(result.body)['data']
  end


  private
  def get(url)

  end
end
