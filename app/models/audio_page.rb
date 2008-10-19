class AudioPage < Page
  description "An Audio page behaves both as an 'index' of all audio tracks in the system, and as a 'show' page for each one of those audio tracks. The 'index' behaviour is used when the path to access the page matches the page slug, e.g. /audio. The 'show' behaviour is triggered when the path to the page includes the slug and the id of an audio track, e.g. /audio/1_first-podcast."
  
  # Allows URLs to direct to the virtual course listing subpage
  def find_by_url(url, live = true, clean = false)
    url = clean_url(url) if clean
    if url =~ %r{#{self.url}(\d+)}
      begin
        @audio_track = Audio.find($1)
        self
      rescue
        super
      end
    else
      self
    end
  end
  
  desc %{
    Usage:
    <pre><code><r:audio:if_index>...</r:audio:if_index></code></pre> }
  tag "audio:if_index" do |tag|
    unless @audio_track
      tag.expand
    end
  end
  
  desc %{
    Usage:
    <pre><code><r:audio:unless_index>...</r:audio:unless_index></code></pre> }
  tag "audio:unless_index" do |tag|
    if @audio_track
      tag.expand
    end
  end
  
  desc %{The namespace for an individual audio track}
  tag "track" do |tag|
    tag.locals.audio_track = @audio_track
    tag.expand
  end
  
  desc %{Renders the title of the current audio track}
  tag "track:title" do |tag|
    tag.locals.audio_track.title
  end
  
  desc %{Renders the tag contents only if the description is not blank}
  tag "track:if_description" do |tag|
    tag.expand unless tag.locals.audio_track.description.blank?
  end
  
  desc %{Renders the tag contents only if the description is blank}
  tag "track:unless_description" do |tag|
    tag.expand if tag.locals.audio_track.description.blank?
  end
  
  desc %{Renders the description of the current audio track}
  tag "track:description" do |tag|
    tag.locals.audio_track.description
  end
  
  desc %{Shows the path for this audio track}
  tag "track:path" do |tag|
    tag.locals.audio_track.path
  end
  
  desc %{Shows the url for this audio track (ie, where it can be downloaded from)}
  tag 'track:url' do |tag|
    tag.locals.audio_track.track.url
  end
  
  desc %{Embed a flash player for this audio track}
  tag 'track:player' do |tag|
    %Q{
      <object type="application/x-shockwave-flash" data="/flash/audio_player/player.swf" id="audioplayer#{tag.locals.audio_track.id}" height="24" width="290">
      <param name="movie" value="/flash/audio_player/player.swf">
      <param name="FlashVars" value="#{player_params(tag.locals.audio_track)}">
      <param name="quality" value="high">
      <param name="menu" value="false">
      <param name="wmode" value="transparent">
      </object>
    }
  end
  
  private
  
  def player_params(audio_track)
    player_prefs = Radiant::Config.find(:all, 
      :conditions => ["config.key LIKE ?", "audio_player.site%"] )
    player_params = ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    player_prefs.each do |pref|
      player_params << "#{pref.key.sub(/audio_player\.site_/, "")}=#{pref.value}"
    end
    # debugger
    player_params.join("&amp;")
  end
  
end