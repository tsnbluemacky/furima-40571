class User < ApplicationRecord
  # Devise modules for user authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations for user attributes
  validates :nickname, presence: true

  with_options presence: true do
    validates :first_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: '全角で入力してください' }
    validates :last_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: '全角で入力してください' }
  end

  with_options presence: true do
    validates :first_name_kana,
              format: { with: /\A[ァ-ヶー－]+\z/, message: '全角カタカナで入力してください' }
    validates :last_name_kana,
              format: { with: /\A[ァ-ヶー－]+\z/, message: '全角カタカナで入力してください' }
  end

  validates :birth_date, presence: true

  validates :password,
            format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]+\z/, message: '半角英数字を入力してください' }

  # Associations(commented out until Product and Order models are created)
  has_many :products, dependent: :destroy
  has_many :orders
end
