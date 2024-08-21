## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |
| name               | string | null: false |  <!-- 追加例 -->
| profile            | text   |             |  <!-- 追加例 -->
| birthday           | date   |             |  <!-- 追加例 -->

### Association

- has_many :items
- has_many :orders


## items テーブル

| Column           | Type    | Options     |
| ---------------- | ------- | ----------- |
| name             | string  | null: false |
| description      | text    | null: false |
| price            | integer | null: false |
| category_id      | integer | null: false |  <!-- foreign_key: true 削除 -->
| condition_id     | integer | null: false |  <!-- foreign_key: true 削除 -->
| shipping_cost_id | integer | null: false |  <!-- foreign_key: true 削除 -->
| shipping_day_id  | integer | null: false |  <!-- foreign_key: true 削除 -->
| user_id          | integer | null: false, foreign_key: true |


## addresses テーブル

| Column        | Type    | Options     |
| ------------- | ------- | ----------- |
| order         | references | null: false, foreign_key: true |
| postal_code   | string  | null: false |
| prefecture_id | integer | null: false |  <!-- カラム名統一 -->
| city          | string  | null: false |
| address       | string  | null: false |
| building      | string  |             |
| phone_number  | string  | null: false |