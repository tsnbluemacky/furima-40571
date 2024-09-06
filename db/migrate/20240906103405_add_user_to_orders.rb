class ChangeUserIdInOrders < ActiveRecord::Migration[7.0]
  def change
    # もし以前にuser_idがinteger型で存在していれば、それを削除します。
    if column_exists?(:orders, :user_id)
      remove_column :orders, :user_id, :integer
    end

    # references型のuser_idを新たに追加し、外部キーを設定します。
    add_reference :orders, :user, foreign_key: true
  end
end