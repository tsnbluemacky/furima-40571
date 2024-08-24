source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Railsの主要なGem
gem "rails", "~> 7.0.0" # Railsフレームワーク
gem "sprockets-rails" # アセットパイプラインのためのGem
gem "mysql2", "~> 0.5" # MySQL用のデータベースアダプター
gem "puma", "~> 5.0" # Rails用のWebサーバー
gem "importmap-rails" # ESMインポートマップを使うためのGem
gem "turbo-rails" # Turbo DriveとTurbo FramesのためのGem
gem "stimulus-rails" # StimulusフレームワークのためのGem
gem "jbuilder" # JSON APIを簡単に構築するためのGem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ] # タイムゾーン情報
gem "bootsnap", require: false # Railsの起動を高速化するためのGem

# 認証関連のGem
gem 'devise' # ユーザー認証機能を提供するGem

# モデル関連のユーティリティ
gem 'active_hash' # データベースを使用しないモデルを作成するためのGem

# 開発環境およびテスト環境用のGem
group :development, :test do
  gem 'rspec-rails', '~> 5.0.0' # テストフレームワークのRSpec
  gem "factory_bot_rails" # テストデータを生成するためのGem
  gem "faker" # テストデータをランダムに生成するためのGem
  gem "debug", platforms: %i[ mri mingw x64_mingw ] # デバッグツール
end

group :development do
  gem "web-console" # ブラウザ上でコンソールを使えるようにするGem
  gem 'rubocop', require: false # コード品質を向上させるための静的解析ツール
  gem "pry-rails" # 拡張されたRailsコンソールを提供するGem
  gem "spring" # Railsコマンドの実行を高速化するプリローダー
end

group :test do
  gem "capybara" # 統合テストを行うためのGem
  gem "selenium-webdriver" # ブラウザの操作を自動化するためのWebDriver
  gem "webdrivers" # WebDriverの管理を自動化するGem
end
