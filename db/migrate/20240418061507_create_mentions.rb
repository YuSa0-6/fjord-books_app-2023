class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioning_report_id, null:false
      t.integer :mentioned_report_id,  null:false
      t.timestamps

      t.index :mentioning_report_id
      t.index :mentioned_report_id
      t.index [:mentioning_report_id, :mentioned_report_id], unique: true
    end
  end
end
