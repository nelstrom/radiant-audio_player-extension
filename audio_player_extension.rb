# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class AudioPlayerExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/audio_player"
  
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