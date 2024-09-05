require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FurimaR735733
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # 日本語をデフォルトロケールに設定
    config.i18n.default_locale = :ja

    # I18nのロードパスを追加
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # ActiveStorageで画像処理をMiniMagickで行う設定
    config.active_storage.variant_processor = :mini_magick

    # PayJPの公開鍵を環境変数から設定
    config.x.api_key = ENV['PAYJP_PUBLIC_KEY']

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
