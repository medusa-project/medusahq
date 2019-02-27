class MedusaClient

  include Singleton

  def get(path, *args)
    args = merge_args(args)
    url = Configuration.instance.medusa_url.chomp('/')
    http_client.get(url + path, args)
  end

  def get_uuid(url, *args)
    get(url_for_uuid(url), args)
  end

  def head(path, *args)
    args = merge_args(args)
    url = Configuration.instance.medusa_url.chomp('/')
    http_client.head(url + path, args)
  end

  private

  def merge_args(args)
    extra_args = { follow_redirect: true }
    if args[0].kind_of?(Hash)
      args[0] = extra_args.merge(args[0])
    else
      return extra_args
    end
    args
  end

  ##
  # @param uuid [String]
  # @return [String, nil] URI of the corresponding Medusa resource.
  #
  def url_for_uuid(uuid)
    sprintf('%s/uuids/%s.json', Configuration.instance.medusa_url.chomp('/'),
            uuid)
  end

  private

  ##
  # @return [HTTPClient] With auth credentials already set.
  #
  def http_client
    unless @http_client
      @http_client = HTTPClient.new do
        config = Configuration.instance
        self.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        self.force_basic_auth = true
        self.receive_timeout = 10000
        uri    = URI.parse(config.medusa_url)
        domain = uri.scheme + '://' + uri.host
        user   = config.medusa_user
        secret = config.medusa_secret
        self.set_auth(domain, user, secret)
      end
    end
    @http_client
  end

end
