class CreateJoinTableAdminsPermissions < ActiveRecord::Migration[7.1]
  def change
    create_join_table :admins, :permissions do |t|
      t.index [:admin_id, :permission_id]
      t.index [:permission_id, :admin_id]
    end
  end
end
