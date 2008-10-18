class AudioPlayerExtension < Radiant::Extension
  version "0.1"
  description "Easily upload mp3 files, and embed them on your site with a Flash audio player."
  url "http://github.com/nelstrom/radiant-audio_player-extension/tree/master"
  
  # define_routes do |map|
  #   map.connect 'admin/audio_player/:action', :controller => 'admin/audio_player'
  # end
  
  def activate
    # admin.tabs.add "Audio Player", "/admin/audio_player", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Audio Player"
  end
  
end