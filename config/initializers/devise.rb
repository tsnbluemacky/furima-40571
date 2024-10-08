# frozen_string_literal: true

Devise.setup do |config|
  # メール送信者の設定
  config.mailer_sender = 'support@example.com'

  # ORMの設定
  require 'devise/orm/active_record'

  # 認証時に使用するキーの設定
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # セッションストレージの設定
  config.skip_session_storage = [:http_auth]

  # パスワードの設定
  config.stretches = Rails.env.test? ? 1 : 12
  config.password_length = 6..128

  # メールの正規表現
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Remember Me の設定
  config.expire_all_remember_me_on_sign_out = true

  # ナビゲーションの設定
  config.navigational_formats = ['*/*', :html, :turbo_stream]

  # ログアウト時のHTTPメソッド
  config.sign_out_via = :delete

  # Turbo対応の設定
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end

