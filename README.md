users テーブル
Column	Type	Options
nickname	string	null: false
surname	string	null: false
given_name	string	null: false
surname_kana	string	null: false
given_name_kana	string	null: false
email	string	null: false, unique: true
encrypted_password	string	null: false
date_of_birth	date	null: false
アソシエーション
has_many
has_many
items テーブル
Column	Type	Options
name	string	null: false
description	text	null: false
price	integer	null: false
user	references	null: false, foreign_key: true
category_id	integer	null: false
condition_id	integer	null: false
shipping_cost_id	integer	null: false
shipping_day_id	integer	null: false
region_id	integer	null: false
アソシエーション
belongs_to
has_one
orders テーブル
Column	Type	Options
item	references	null: false, foreign_key: true
user	references	null: false, foreign_key: true
アソシエーション
belongs_to
belongs_to
has_one
addresses テーブル
Column	Type	Options
order	references	null: false, foreign_key: true
postal_code	string	null: false
prefecture_id	integer	null: false
city	string	null: false
street_address	string	null: false
building_name	string	
phone_number	string	null: false
アソシエーション
belongs_to
