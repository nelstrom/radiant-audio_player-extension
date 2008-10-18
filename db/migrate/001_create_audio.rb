class CreateAudio < ActiveRecord::Migration
  def self.up
    create_table :audios do |t|
      t.string :title
      t.text :description
      t.string :filter
      t.integer :created_by_id, :updated_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :audios
  end
end
