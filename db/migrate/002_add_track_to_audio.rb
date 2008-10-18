class AddTrackToAudio < ActiveRecord::Migration
  def self.up
    add_column :audio, :track_file_name, :string
    add_column :audio, :track_content_type, :string
    add_column :audio, :track_file_size, :integer
    
  end

  def self.down
    remove_column :audio, :track_file_name
    remove_column :audio, :track_content_type
    remove_column :audio, :track_file_size
  end
end
