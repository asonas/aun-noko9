class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :message, null: false

      t.timestamps null: false
    end
  end
end
