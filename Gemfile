source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.0.0"
gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

gem 'devise' # ユーザー認証機能のためのGem
gem 'active_hash' # モデルの代替として使用するためのGem

group :development, :test do
  gem 'rspec-rails', '~> 5.0.0' # RSpec for testing framework
  gem "debug", platforms: %i[ mri mingw x64_mingw ] # デバッグツール
end

group :development do
  gem "web-console" # 開発環境でのコンソール使用
  gem 'rubocop', require: false # コード品質向上のための静的解析ツール
end

group :test do
  gem "capybara" # 統合テスト用
  gem "selenium-webdriver" # Capybaraと組み合わせてブラウザを操作
  gem "webdrivers" # SeleniumのためのWebDriver管理
end
