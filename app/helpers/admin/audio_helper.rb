module Admin::AudioHelper
  
  def admin_player_params(audio_track)
    if config = AudioPlayerConfig.find_by_name("Admin")
      player_params = config.parameters_for_player
    else
      player_params = ["autostart=no","loop=no"]
    end
    player_params += ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    player_params.join("&amp;")
  end
  
  
  
end
