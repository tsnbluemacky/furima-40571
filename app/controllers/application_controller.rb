class ApplicationController < ActionController::Base
  # Basic認証を設定
  before_action :basic_auth

  private

  # Basic認証の設定
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
