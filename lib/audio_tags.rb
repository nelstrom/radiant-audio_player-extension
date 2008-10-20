module AudioTags
  include Radiant::Taggable
  
  desc %Q{
    Embed the javascript code which is required to make the Flash player work.
  }
  tag 'tracks:script' do |tag|
    %Q{<script type="text/javascript" src="/javascripts/audio_player/audio-player.js"></script>}
  end
  
  desc %{The namespace for all audio tags}
  tag 'tracks' do |tag|
    tag.expand
  end
  
  desc %{Returns all audio tracks}
  tag 'tracks:each' do |tag|
    audio_tracks = []
    tag.locals.audio_tracks = Audio.find(:all, :order => "position ASC")
    tag.locals.audio_tracks.each do |track|
      tag.locals.audio_track = track
      audio_tracks << tag.expand
    end
    audio_tracks
  end
  
  desc %{  Renders the title of the current audio track.}
  tag "tracks:each:title" do |tag|
    tag.locals.audio_track.title
  end
  
  desc %{  Renders the title of the current audio track.}
  tag "tracks:each:description" do |tag|
    tag.locals.audio_track.description_with_filter
  end
  
  [:title, :description].each do |column|
    desc %{  Renders contents unless the `#{column}' attribute is blank.}
    tag "movies:each:if_#{column}" do |tag|
      tag.expand unless tag.locals.audio_track[column].blank?
    end
  end
  
  desc %{
    Embeds the current audio track on the page, using the flash player.}
  tag 'tracks:each:player' do |tag|
    %Q{<object type="application/x-shockwave-flash" data="/flash/audio_player/player.swf" id="audioplayer#{tag.locals.audio_track.id}" height="24" width="290">
<param name="movie" value="/flash/audio_player/player.swf">
<param name="FlashVars" value="#{player_params(tag.locals.audio_track)}">
<param name="quality" value="high">
<param name="menu" value="false">
<param name="wmode" value="transparent">
</object>}
  end
  
  desc %{
    Provides a link to the virtual page for this audio track.
    
    Note that this tag will only work if your site has one page of type AudioPage. 
    If you have more than one Audio Page, or no Audio Pages, then this tag won't work.
  }
  tag 'tracks:each:link' do |tag|
    track = tag.locals.audio_track
    if path = track.path
      text = tag.double? ? tag.expand : track.title
      %{<a href="#{path}" title="#{track.title}">#{text}</a>}
    else
      "You must have exactly 1 Audio page for this tag to work."
    end
  end
  
  private
  
  def player_params(audio_track)
    player_prefs = Radiant::Config.find(:all, 
      :conditions => ["config.key LIKE ?", "audio_player.site%"] )
    player_params = ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    player_prefs.each do |pref|
      player_params << "#{pref.key.sub(/audio_player\.site_/, "")}=#{pref.value}"
    end
    player_params.join("&amp;")
  end
  
end