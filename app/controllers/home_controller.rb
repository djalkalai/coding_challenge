class HomeController < ApplicationController
  def index
    client = TwitterOAuth::Client.new(
    :consumer_key => '2gUE1WXvP7Kq1GjlrptmuA7vv',
    :consumer_secret => '5oBbhgEfsdvSpGD31cr5ftu7BemzT1oe2JWlVxLkKphRWrHTaV'
    )

    request_token = client.request_token(:oauth_callback => oauth_confirm_url)

    session[:client] = client
    session[:request_token] = request_token

    redirect_to request_token.authorize_url
  end

  def show
    return redirect_to '/index' unless authenticated?

    client = session[:client]
    request_token = session[:request_token]
    access_token = session[:access_token]

    unless access_token
      access_token = client.authorize(
      request_token.token,
      request_token.secret,
      oauth_verifier: params[:oauth_verifier]
      )
      session[:access_token] = access_token
    end

    @handle = params[:handle] || "StephenAtHome"
    count = params[:count] || 25
    @tweets = app_client.user_timeline(@handle, count: count)
  end

  protected

  def authenticated?
    return session[:client] && session[:request_token]
  end

  def app_client
    @app_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = "2gUE1WXvP7Kq1GjlrptmuA7vv"
      config.consumer_secret = "5oBbhgEfsdvSpGD31cr5ftu7BemzT1oe2JWlVxLkKphRWrHTaV"
      config.access_token = "3277903424-F4z7d6YrKyuJecvAQXhWmPqPiKPL5n081DC9cBe"
      config.access_token_secret = "P3R6pGUMaxKMVlnl3itG2dVr72bTRxag8LGSgZ9d3ptHu"
    end
  end

  def oauth_confirm_url
    # "http://127.0.0.1:3000/show"
    "https://daniel-stack-commerce.herokuapp.com/show"
  end
end
