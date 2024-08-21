## users テーブル

| Column              | Type       | Options                        |
|---------------------|------------|--------------------------------|
| username            | string     | null: false                    |
| surname             | string     | null: false                    |
| given_name          | string     | null: false                    |
| surname_kana        | string     | null: false                    |
| given_name_kana     | string     | null: false                    |
| email_address       | string     | null: false, unique: true      |
| password_digest     | string     | null: false                    |
| date_of_birth       | date       | null: false                    |

### アソシエーション

- has_many :items, foreign_key: 'seller_id'
- has_many :orders, foreign_key: 'buyer_id'


## items テーブル

| Column              | Type       | Options                        |
|---------------------|------------|--------------------------------|
| title               | string     | null: false                    |
| description         | text       | null: false                    |
| price               | integer    | null: false                    |
| user_id             | references | null: false, foreign_key: true |
| category_id         | integer    | null: false                    |
| condition_id        | integer    | null: false                    |
| shipping_fee_id     | integer    | null: false                    |
| region_id           | integer    | null: false                    |
| delivery_time_id    | integer    | null: false                    |

### アソシエーション

- belongs_to :user, foreign_key: 'seller_id'
- has_one :order


## orders テーブル

| Column              | Type       | Options                        |
|---------------------|------------|--------------------------------|
| item_id             | references | null: false, foreign_key: true |
| user_id             | references | null: false, foreign_key: true |

### アソシエーション

- belongs_to :user, foreign_key: 'buyer_id'
- belongs_to :item
- has_one :shipping_detail


## shipping_details テーブル

| Column              | Type       | Options                        |
|---------------------|------------|--------------------------------|
| order_id            | references | null: false, foreign_key: true |
| postal_code         | string     | null: false                    |
| contact_number      | string     | null: false                    |
| region_id           | integer    | null: false                    |
| city_name           | string     | null: false                    |
| street_address      | string     | null: false                    |
| building_name       | string     |                                |

### アソシエーション

- belongs_to :order