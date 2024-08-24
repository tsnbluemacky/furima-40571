class User < ApplicationRecord
  # Deviseモジュールの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネームは一意であり必須項目とする
  validates :nickname, presence: true, uniqueness: true

  # 姓名に関するバリデーション（ひらがな・カタカナ・漢字のみ許可）
  with_options presence: true do
    validates :first_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid. Input full-width characters' }
    validates :last_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is invalid. Input full-width characters' }
  end

  # 姓名のカナに関するバリデーション（カタカナのみ許可）
  with_options presence: true do
    validates :first_name_kana,
              format: { with: /\A[\p{katakana}\u{30fc}]+\z/, message: 'is invalid. Input full-width katakana characters' }
    validates :last_name_kana,
              format: { with: /\A[\p{katakana}\u{30fc}]+\z/, message: 'is invalid. Input full-width katakana characters' }
  end

  # 生年月日のバリデーション
  validates :birth_date, presence: true

  # パスワードのバリデーション（英字と数字を両方含む）
  validates :password, presence: true, length: { minimum: 6 },
                       format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]+\z/, message: 'must include both letters and numbers' }, on: :create
  validates :password, format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]+\z/, message: 'must include both letters and numbers' }, allow_nil: true,
                       on: :update

  # 重複エラーメッセージの削除
  validate :check_for_duplicate_errors

  private

  def check_for_duplicate_errors
    return unless errors[:password].any?

    errors[:password].uniq!
  end
end
