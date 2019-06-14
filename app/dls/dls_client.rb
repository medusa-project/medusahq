class DlsClient

  include Singleton

  def get(path, *args)
    args = merge_args(args)
    url = Settings.dls_url.chomp('/')
    http_client.get(url + path, args)
  end

  def head(path, *args)
    args = merge_args(args)
    url = Settings.dls_url.chomp('/')
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

  def http_client
    unless @http_client
      @http_client = HTTPClient.new do
        self.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        #self.force_basic_auth = true
        self.receive_timeout = 10000
        uri    = URI.parse(Settings.dls_url)
        domain = uri.scheme + '://' + uri.host
        # user   = Settings.medusa_user
        # secret = Settings.medusa_secret
        #self.set_auth(domain, user, secret)
      end
    end
    @http_client
  end

end