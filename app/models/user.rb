class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KANA_REGEX = /\A[ァ-ヶー]+\z/

  validates :nickname, presence: true
  # Ensure passwords include both letters and numbers using half-width characters
  validates :password, format: { with: PASSWORD_REGEX, message: 'は半角英数字で入力してください' }

  with_options presence: true do
    validates :first_name, format: { with: NAME_REGEX}
    validates :last_name, format: { with: NAME_REGEX}
    # Validate phonetic name fields are full-width katakana characters
    validates :first_name_kana, format: { with: KANA_REGEX, message: 'は全角カタカナで入力してください'}
    validates :last_name_kana, format: { with: KANA_REGEX, message: 'は全角カタカナで入力してください'}
    validates :birth_date
  end
end
