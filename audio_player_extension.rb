class AudioPlayerExtensionError < StandardError; end

class AudioPlayerExtension < Radiant::Extension
  version "0.1"
  description "Easily upload mp3 files, and embed them on your site with a Flash audio player."
  url "http://github.com/nelstrom/radiant-audio_player-extension/tree/master"

  define_routes do |map|
    map.with_options(:controller => 'admin/audio') do |audio|
      audio.audio_index           'admin/audio',              :action => 'index'
      audio.audio_new             'admin/audio/new',          :action => 'new'
      audio.audio_edit            'admin/audio/edit/:id',     :action => 'edit'
      audio.audio_remove          'admin/audio/remove/:id',   :action => 'remove'
      audio.audio_reorder         'admin/audio/reorder',      :action => 'reorder'
      audio.audio_update_order    'admin/audio/update_order', :action => 'update_order'
    end
    
    map.with_options(:controller => 'admin/audio_player_config') do |config|
      config.audio_player_config_index  'admin/audio_player_config',            :action => 'index'
      config.audio_player_config_new    'admin/audio_player_config/new',        :action => 'new'
      config.audio_player_config_edit   'admin/audio_player_config/edit/:id',   :action => 'edit'
      config.audio_player_config_remove 'admin/audio_player_config/remove/:id', :action => 'remove'
    end

  end

  def activate
    Inflector.inflections do |inflect|
      inflect.uncountable "audio" # cause 'audios' just sounds wrong!
    end
    admin.tabs.add "Audio", "/admin/audio", :after => "Layouts", :visibility => [:all]
    Page.send :include, AudioTags
    AudioPage
  end

  def deactivate
  end




  # def load_configuration
  #   Radiant::Config.destroy_all(["config.key LIKE ?", "audio_player%"])
  #   # load_yaml('audio_player') do |configurations|
  #   #   configurations.each do |key, value|
  #   #     if value.is_a?(Hash)
  #   #       value.each do |k,v|
  #   #         Radiant::Config["audio_player.#{key}_#{k}"] = v
  #   #       end
  #   #     end
  #   #   end
  #   # end
  # end

  # private
  # 
  #   def load_yaml(filename)
  #     config_path = File.join(RAILS_ROOT, 'config', 'extensions', 'audio_player')
  #     filename = File.join(config_path, "#{filename}.yml")
  #     raise AudioPlayerExtensionError.new("AudioPlayerExtension error: #{filename} doesn't exist. Run the install task and try again.") unless File.exists?(filename)
  #     data = YAML::load_file(filename)
  #     yield(data)
  #   end

end