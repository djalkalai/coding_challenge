class HomeController < ApplicationController

  DEFAULT_COUNT = 25

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

  def start
  end

  def logout
    session[:client] = nil if session[:client]
    session[:request_token] = nil if session[:request_token]
    session[:access_token] = nil if session[:access_token]

    redirect_to '/start'
  end

  def show
    return redirect_to '/start' unless authenticated?

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

    @user_handle = access_token.params[:screen_name]
    @handle = params[:handle] || @user_handle
    @count = params[:count] || DEFAULT_COUNT
    @tweets = app_client.user_timeline(@handle, count: @count)

    if params.include? 'oauth_token'
      return redirect_to "/show?handle=#{@handle}&count=#{@count}"
    end
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
    "https://daniel-stack-commerce.herokuapp.com/show"
  end
end
