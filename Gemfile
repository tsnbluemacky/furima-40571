source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Railsの主要なGem
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

# 画像処理用のGem
gem 'image_processing', '~> 1.2'
gem 'mini_magick' # 追加

# 認証関連のGem
gem 'devise'

# モデル関連のユーティリティ
gem 'active_hash'

# データをJavaScriptに渡すためのGem
gem 'gon'

# 開発環境およびテスト環境用のGem
group :development, :test do
  gem 'rspec-rails', '~> 5.0.0'
  gem "factory_bot_rails"
  gem "faker"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem 'rubocop', require: false
  gem "pry-rails"
  gem "spring"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
