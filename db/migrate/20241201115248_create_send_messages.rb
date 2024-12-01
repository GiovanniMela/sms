class CreateSendMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :send_messages do |t|
      t.text :value, null: false

      t.timestamps
    end
  end
end
