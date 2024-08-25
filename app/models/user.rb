class User < ApplicationRecord
  # Devise modules for user authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations for user attributes
  validates :nickname, presence: true

  with_options presence: true do
    validates :first_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid. Input full-width characters' }
    validates :last_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid. Input full-width characters' }
  end

  with_options presence: true do
    validates :first_name_kana,
              format: { with: /\A[\p{katakana}\u{30fc}]+\z/, message: 'is invalid. Input full-width katakana characters' }
    validates :last_name_kana,
              format: { with: /\A[\p{katakana}\u{30fc}]+\z/, message: 'is invalid. Input full-width katakana characters' }
  end

  validates :birth_date, presence: true

  validates :password,
            format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]+\z/, message: 'must include both letters and numbers' }

  # Removing redundant validations
  # Devise handles presence and length validations for password

  # Removing custom error message check for password uniqueness
  # No need for custom logic to handle password error uniqueness

  # Any other methods or custom validations can be added below
end
