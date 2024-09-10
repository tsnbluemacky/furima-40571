class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KANA_REGEX = /\A[ァ-ヶー]+\z/

  validates :nickname, presence: true
  validates :password, format: { with: PASSWORD_REGEX }

  with_options presence: true do
    validates :first_name, format: { with: NAME_REGEX}
    validates :last_name, format: { with: NAME_REGEX}
    validates :first_name_kana, format: { with: KANA_REGEX}
    validates :last_name_kana, format: { with: KANA_REGEX}
    validates :birth_date
  end
end
