class AddPositionToAudio < ActiveRecord::Migration
  def self.up
    add_column :audio, :position, :integer
  end

  def self.down
    remove_column :audio, :position
  end
end
