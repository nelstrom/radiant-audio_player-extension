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
  
  ["if_index", "unless_show"].each do |condition|
    desc %{ The contents of this tag are rendered only when this AudioPage is
      being called in the context of an index page. E.g. path: /audio/ }
    tag "tracks:#{condition}" do |tag|
      unless @audio_track
        tag.expand
      end
    end
  end
  
  ["unless_index", "if_show"].each do |condition|
    desc %{ The contents of this tag are rendered only in the context of this
      AudioPage as a "Show" page. E.g. when the path is: /audio/1_episode-one/ }
    tag "tracks:#{condition}" do |tag|
      if @audio_track
        tag.expand
      end
    end
  end
  
  desc %{The namespace for an individual audio track.}
  tag "track" do |tag|
    tag.locals.audio_track = @audio_track
    tag.expand
  end

  
  desc %{The contents of this tag are rendered only if this track has a successor}
  tag "track:if_next" do |tag|
    tag.locals.next_track = Audio.find(:first, 
      :conditions => ["position > ?", tag.locals.audio_track.position],
      :order => "position ASC")
    tag.expand if tag.locals.next_track
  end
  
  desc %{The contents of this tag are rendered only if this track has a predecessor}
  tag "track:if_previous" do |tag|
    tag.locals.previous_track = Audio.find(:first, 
      :conditions => ["position < ?", tag.locals.audio_track.position], 
      :order => 'position DESC')
    tag.expand if tag.locals.previous_track
  end
  
  desc %{Transfers the context to the next track}
  tag "track:next" do |tag|
    if next_track = Audio.find(:first, 
      :conditions => ["position > ?", tag.locals.audio_track.position],
      :order => 'position ASC')
      tag.locals.audio_track = next_track
      tag.expand
    end
  end
  
  desc %{Transfers the context to the previous track}
  tag "track:previous" do |tag|
    if previous_track = Audio.find(:first, 
      :conditions => ["position < ?", tag.locals.audio_track.position], 
      :order => 'position DESC')
      tag.locals.audio_track = previous_track
      tag.expand
    end
  end
  
  private
  
  def player_params(audio_track)
    if config = AudioPlayerConfig.find_by_name("Site")
      player_params = config.parameters_for_player
    else
      player_params = ["autostart=no","loop=no"]
    end
    player_params += ["playerID=#{audio_track.id}","soundFile=#{audio_track.track.url}"]
    player_params.join("&amp;")
  end
  
end