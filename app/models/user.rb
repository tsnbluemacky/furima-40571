class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :items
  # has_many :purchase_records # 購入履歴の関連付けをコメントアウト

  # Constants for validation
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KANA_REGEX = /\A[ァ-ヶー]+\z/

  # Validations
  validates :nickname, presence: true
  validates :password, format: { with: PASSWORD_REGEX, message: 'は半角英数字で入力してください' }

  with_options presence: true do
    validates :first_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
    validates :last_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
    validates :first_name_kana, format: { with: KANA_REGEX, message: 'は全角カタカナで入力してください' }
    validates :last_name_kana, format: { with: KANA_REGEX, message: 'は全角カタカナで入力してください' }
    validates :birth_date, presence: true
  end
end
