class CreateAudioPlayerConfig < ActiveRecord::Migration
  def self.up
    
    create_table :audio_player_configs do |t|
      t.string :name
      t.string :bg, :leftbg, :lefticon, :rightbg, :rightbghover, :righticon, :righticonhover, :text, :slider, :track, :border, :loader
      t.boolean :loop, :autostart
    end
  end
  
  def self.down
    drop_table :audio_player_configs
  end
end
