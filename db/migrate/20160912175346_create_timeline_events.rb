class CreateTimelineEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :timeline_events do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :location
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :at_present
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
