class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :name

      t.timestamps
    end
    add_index :instruments, :name
  end
end
