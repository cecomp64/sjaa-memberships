class CreateApiKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :api_keys do |t|
      t.integer :bearer_id, null: false
      t.string :bearer_type, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :api_keys, [:bearer_id, :bearer_type]
    add_index :api_keys, :token, unique: true
  end
end
