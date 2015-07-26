class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :content_type
      t.string :size

      t.timestamps
    end
  end
end
