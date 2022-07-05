module OauthMultipart
end

OAuth2::AccessToken.class_eval do

  def post_with_multipart(*args)
    multipart_post *args
  end

  def multipart_post(*args)
    request(:post, *args)
  end
end
