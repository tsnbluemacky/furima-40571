class ApplicationController < ActionController::Base
  # Deviseコントローラーの場合、追加のパラメータ設定を許可する
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Deviseのストロングパラメーターを設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        :nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date
                                      ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
                                        :nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date
                                      ])
  end
end
