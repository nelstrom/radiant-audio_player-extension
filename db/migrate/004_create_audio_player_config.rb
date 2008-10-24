class CreateAudioPlayerConfig < ActiveRecord::Migration
  def self.up
    
    create_table :audio_player_configs do |t|
      t.string :name
      t.string :bg, :leftbg, :lefticon, :rightbg, :rightbghover, :righticon, :righticonhover, :text, :slider, :track, :border, :loader
      t.boolean :loop, :autostart
    end
    
    # Create two default players: Admin (unstyled) and Site (minimal modifications)
    AudioPlayerConfig.create({:name => "Admin"})
    AudioPlayerConfig.create({
      :name => "Site",
      :bg => "0xf8f8f8",
      :leftbg => "0xeeeeee",
      :lefticon => "0x666666",
      :rightbg => "0xcccccc",
      :rightbghover => "0x999999",
      :righticon => "0x666666",
      :righticonhover => "0xffffff",
      :text => "0x666666",
      :slider => "0x666666",
      :track => "0xFFFFFF",
      :border => "0x666666",
      :loader => "0x9FFFB8",
      :loop => false,
      :autostart => false
    })
    
  end
  
  def self.down
    drop_table :audio_player_configs
  end
end
