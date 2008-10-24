module Admin::AudioHelper
  
  def admin_player_params(audio_track)
    # player_prefs = Radiant::Config.find(:all, 
    #   :conditions => ["config.key LIKE ?", "audio_player.admin%"] )
    # player_params = ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    # player_prefs.each do |pref|
    #   player_params << "#{pref.key.sub(/audio_player\.admin_/, "")}=#{pref.value}"
    # end
    # # debugger
    # player_params.join("&amp;")
    
    player_params = []
    if config = AudioPlayerConfig.find_by_name("Admin")
      player_params = config.parameters_for_player
    else
      player_params = ["autostart=no","loop=no"]
    end
    player_params += ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    player_params.join("&amp;")
  end
  
  
  
end
