require File.dirname(__FILE__) + '/../spec_helper'

describe "Audio tags" do
  scenario :audio_page_scenario
  
  before(:each) do
    # @audio_track = Audio.find(:first, :order => 'position ASC')
    # @virtual_audio_page = Page.find_by_url("/audio/#{@audio_track.to_param}")
    @page = pages(:home)
    @audio_tracks = Audio.find(:all, :order => 'position ASC')
  end
  
  it "should render contents of r:audio" do
    @page.should render('<r:audio>Whatever</r:audio>').as('Whatever')
  end
  
  it "should render contents of r:audio:each for each audio track" do
    @page.should render('<r:audio:each>a </r:audio:each>').as('a a ')
  end
  
  it "should render contents of r:audio:each for each audio track" do
    @page.should render('<r:audio:each><r:title/> </r:audio:each>').
      as(@audio_tracks.map{ |track| "#{track.title} " }.join)
  end
  
  
  it "should render description of each audio track with r:audio:each:description" do
    @page.should render('<r:audio:each><p><r:description/></p></r:audio:each>').
      as(@audio_tracks.map{ |track| "<p>#{track.description}</p>" }.join)
  end
  
  it "should find the url for audio tracks with r:link" do
    @page.should render('<r:audio:each><r:link/> </r:audio:each>').
      as(%Q{<a href=\"/audio/#{@audio_tracks[0].id}-debut\" title=\"Debut\">Debut</a> <a href=\"/audio/#{@audio_tracks[1].id}-mostly-harmless\" title=\"Mostly harmless\">Mostly harmless</a> })
  end
  
  it "should output code for embedded player with r:track:player" do
    # debugger
    @page.should render('<r:audio:each><r:player/></r:audio:each>').
      as(@audio_tracks.map{ |track| embed_helper(track) }.join)
  end
  
  private
  
  def embed_helper(audio_track)
    %Q{<object type=\"application/x-shockwave-flash\" data=\"/flash/audio_player/player.swf\" id=\"audioplayer#{audio_track.id}\" height=\"24\" width=\"290\">
<param name=\"movie\" value=\"/flash/audio_player/player.swf\">
<param name=\"FlashVars\" value=\"playerID=#{audio_track.id}&amp;soundFile=/audio/#{audio_track.id}/#{audio_track.track_file_name}&amp;lefticon=0x666666&amp;autostart=no&amp;loader=0x9FFFB8&amp;text=0x666666&amp;track=0xFFFFFF&amp;border=0x666666&amp;slider=0x666666&amp;rightbg=0xcccccc&amp;leftbg=0xeeeeee&amp;bg=0xf8f8f8&amp;righticonhover=0xffffff&amp;loop=no&amp;rightbghover=0x999999&amp;righticon=0x666666\">
<param name=\"quality\" value=\"high\">
<param name=\"menu\" value=\"false\">
<param name=\"wmode\" value=\"transparent\">
</object>}
  end
  
end