class AudioPlayerExtension < Radiant::Extension
  version "0.1"
  description "Easily upload mp3 files, and embed them on your site with a Flash audio player."
  url "http://github.com/nelstrom/radiant-audio_player-extension/tree/master"
  
  define_routes do |map|
    # map.connect 'admin/audio_player/:action', :controller => 'admin/audio_player'
    map.with_options(:controller => 'admin/audio') do |audio|
      audio.audio_index           'admin/audio',             :action => 'index'
      audio.audio_new             'admin/audio/new',         :action => 'new'
      audio.audio_edit            'admin/audio/edit/:id',    :action => 'edit'
      audio.audio_remove          'admin/audio/remove/:id',  :action => 'remove'
    end
    
    
  end
  
  def activate
    Inflector.inflections do |inflect|
      inflect.uncountable "audio" # cause 'audios' just sounds wrong!
    end
    
    admin.tabs.add "Audio", "/admin/audio", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Audio Player"
  end
  
end