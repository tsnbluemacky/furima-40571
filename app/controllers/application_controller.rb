class ApplicationController < ActionController::Base
  # Deviseコントローラーの場合、追加のパラメータ設定を許可する
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Basic認証を有効にする
  before_action :basic_auth

  private

  # Deviseのストロングパラメーターを設定
  def configure_permitted_parameters
    # ここでDeviseの許可パラメーターを設定することができますが、
    # 今回の例では特に追加のパラメーターはありません。
  end

  # Basic認証の設定
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end
end
