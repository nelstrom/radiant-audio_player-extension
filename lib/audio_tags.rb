module AudioTags
  include Radiant::Taggable
  
  desc %Q{
    Embed the javascript code which is required to make the Flash player work.
  }
  tag 'tracks:script' do |tag|
    %Q{<script type="text/javascript" src="/javascripts/audio_player/audio-player.js"></script>}
  end
  
  desc %{Find a track, by passing its id or title. This allows you to embed any audio track on any page of your choice, rather than depending on the Audio Page type.}
  tag 'track' do |tag|
    if tag.attr["id"] or tag.attr["title"]
      if id = tag.attr["id"]
        if track = Audio.find(id.to_i) rescue nil
          tag.locals.audio_track = track
          tag.expand
        end
      elsif title = tag.attr["title"]
        if track = Audio.find_by_title(title)
          tag.locals.audio_track = track
          tag.expand
        end
      end
    else
      "To accesss an audio track, you must supply an attribute with its id or title"
    end
  end
  
  # ------------
  
  
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
      tag.locals.audio_track.description_with_filter
    end

    desc %{Shows the path for this audio track}
    tag "track:path" do |tag|
      tag.locals.audio_track.path
    end

    desc %{Shows the url for this audio track (ie, where it can be downloaded from)}
    tag 'track:url' do |tag|
      tag.locals.audio_track.url
    end

    desc %{Embed a flash player for this audio track}
    tag 'track:player' do |tag|
      %Q{<object type="application/x-shockwave-flash" data="/flash/audio_player/player.swf" id="audioplayer#{tag.locals.audio_track.id}" height="24" width="290">
  <param name="movie" value="/flash/audio_player/player.swf">
  <param name="FlashVars" value="#{player_params(tag.locals.audio_track)}">
  <param name="quality" value="high">
  <param name="menu" value="false">
  <param name="wmode" value="transparent">
  </object>}
    end
  
  # ------------
  
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