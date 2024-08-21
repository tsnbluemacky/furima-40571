## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false |
| encrypted_password | string | null: false |

### Association

- has_many :items
- has_many :orders

## items テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------- |
| name             | string  | null: false |
| description      | text    | null: false |
| price            | integer | null: false |
| category_id      | integer | null: false, foreign_key: true |
| condition_id     | integer | null: false, foreign_key: true |
| shipping_cost_id | integer | null: false, foreign_key: true |
| shipping_day_id  | integer | null: false, foreign_key: true |
| user_id          | integer | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :order

## orders テーブル

| Column   | Type    | Options                       |
| -------- | ------- | ----------------------------- |
| user_id  | integer | null: false, foreign_key: true |
| item_id  | integer | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## addresses テーブル

| Column        | Type    | Options                       |
| ------------- | ------- | ----------------------------- |
| order_id      | integer | null: false, foreign_key: true |
| postal_code   | string  | null: false                   |
| prefecture_id | integer | null: false, foreign_key: true |
| city          | string  | null: false                   |
| address       | string  | null: false                   |
| building      | string  |                               |
| phone_number  | string  | null: false                   |

### Association

- belongs_to :order
