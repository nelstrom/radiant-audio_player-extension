require File.dirname(__FILE__) + '/../spec_helper'

describe AudioPage do
  scenario :audio_page
  
  before(:each) do
    @audio_track = Audio.find(:first, :order => 'position ASC')
    @virtual_audio_page = Page.find_by_url("/audio/#{@audio_track.to_param}")
  end
  
  it "should find the audio listings page at /audio" do
    Page.find_by_url('/audio').should == pages(:audio)
  end
  
  it "should find the virtual audio page at /audio/id-slug" do
    Page.find_by_url("/audio/#{@audio_track.to_param}").should == pages(:audio)
  end
  
  it "should be an index page at /audio" do
    Page.find_by_url('/audio').should render('<r:tracks:if_index>YES!</r:tracks:if_index>').as('YES!')
    Page.find_by_url('/audio').should render('<r:tracks:unless_show>YES!</r:tracks:unless_show>').as('YES!')
    Page.find_by_url('/audio').should render('<r:tracks:unless_index>hidden</r:tracks:unless_index>').as('')
    Page.find_by_url('/audio').should render('<r:tracks:if_show>hidden</r:tracks:if_show>').as('')
  end
  it "should not be an index page at /audio/id-slug" do
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:tracks:if_index>hidden</r:tracks:if_index>').as('')
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:tracks:unless_show>hidden</r:tracks:unless_show>').as('')
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:tracks:if_show>YES!</r:tracks:if_show>').as('YES!')
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:tracks:unless_index>YES!</r:tracks:unless_index>').as('YES!')
  end
  
  it "should show contents of r:track" do
    @virtual_audio_page.should render('<r:track>hi!</r:track>').as('hi!')
  end
  
  it "should show title with r:track:title" do
    @virtual_audio_page.should render('<r:track><r:title/></r:track>').as('Debut')
  end
  
  it "should show description with r:track:description" do
    @virtual_audio_page.should render('<r:track><r:description/></r:track>').as('Her first recording.')
  end
  
  it "should use specified filter for description" do
    audio_track = Audio.find_by_title("Richly described")
    virtual_audio_page = Page.find_by_url("/audio/#{audio_track.to_param}")
    virtual_audio_page.should render('<r:track><r:description/></r:track>').as("<p>How <strong>do</strong> you do?</p>")
  end
  
  it "should show url with r:track:url" do
    @virtual_audio_page.should render('<r:track><r:url/></r:track>').
      as("/audio/#{@audio_track.id}/#{@audio_track.track_file_name}")
  end
  
  it "should show path with r:track:path" do
    @virtual_audio_page.should render('<r:track><r:path/></r:track>').as(@audio_track.path)
  end
  
  it "should output code for embedded player with r:track:player" do
    @virtual_audio_page.should render('<r:track><r:player/></r:track>').
        as(embed_helper(@audio_track))
#       as(%Q{<object type=\"application/x-shockwave-flash\" data=\"/flash/audio_player/player.swf\" id=\"audioplayer#{@audio_track.id}\" height=\"24\" width=\"290\">
# <param name=\"movie\" value=\"/flash/audio_player/player.swf\">
# <param name=\"FlashVars\" value=\"playerID=#{@audio_track.id}&amp;soundFile=/audio/#{@audio_track.id}/#{@audio_track.track_file_name}&amp;lefticon=0x666666&amp;autostart=no&amp;loader=0x9FFFB8&amp;text=0x666666&amp;track=0xFFFFFF&amp;border=0x666666&amp;slider=0x666666&amp;rightbg=0xcccccc&amp;leftbg=0xeeeeee&amp;bg=0xf8f8f8&amp;righticonhover=0xffffff&amp;loop=no&amp;rightbghover=0x999999&amp;righticon=0x666666\">
# <param name=\"quality\" value=\"high\">
# <param name=\"menu\" value=\"false\">
# <param name=\"wmode\" value=\"transparent\">
# </object>})
  end
  
  # previous/next specs
  
  
  it "should render contents of r:track:if_next when track has a successor" do
    track = Audio.find_by_title("Debut")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:if_next>YES</r:if_next></r:track>').as('YES')
  end
  
  it "should not render contents of r:track:if_previous when track has no predecessor" do
    track = Audio.find_by_title("Debut")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:if_previous>hidden</r:if_previous></r:track>').as('')
  end
  
  it "should not render contents of r:track:if_next when track has no successor" do
    track = Audio.find_by_title("Richly described")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:if_next>hidden</r:if_next></r:track>').as('')
  end
  
  it "should render contents of r:track:if_previous when track has a predecessor" do
    track = Audio.find_by_title("Mostly harmless")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:if_previous>YES</r:if_previous></r:track>').as('YES')
  end
  
  it "should transfer context to next track with track:next" do
    track, successor = Audio.find(:all, :order => "position ASC")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:next><r:title/></r:next></r:track>').as(successor.title)
    virtual_audio_page.should render('<r:track><r:next><r:url/></r:next></r:track>').as(successor.url)
  end
  
  it "should transfer context to previous track with track:previous" do
    track, predecessor = Audio.find(:all, :order => "position DESC")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:previous><r:title/></r:previous></r:track>').as(predecessor.title)
    virtual_audio_page.should render('<r:track><r:previous><r:url/></r:previous></r:track>').as(predecessor.url)
  end
  
  
  it "should transfer context to next track with track:next, again" do
    track, successor, sucsucsessor = Audio.find(:all, :order => "position ASC")
    virtual_audio_page = Page.find_by_url("/audio/#{track.to_param}")
    virtual_audio_page.should render('<r:track><r:next><r:next><r:title/></r:next></r:next></r:track>').as(sucsucsessor.title)
    virtual_audio_page.should render('<r:track><r:next><r:next><r:url/></r:next></r:next></r:track>').as(sucsucsessor.url)
  end
  
  private
  
  def embed_helper(audio_track)
    %Q{<object type=\"application/x-shockwave-flash\" data=\"/flash/audio_player/player.swf\" id=\"audioplayer#{audio_track.id}\" height=\"24\" width=\"290\">
<param name=\"movie\" value=\"/flash/audio_player/player.swf\">
<param name=\"FlashVars\" value=\"autostart=no&amp;loop=no&amp;playerID=#{audio_track.id}&amp;soundFile=/audio/#{audio_track.id}/#{audio_track.track_file_name}\">
<param name=\"quality\" value=\"high\">
<param name=\"menu\" value=\"false\">
<param name=\"wmode\" value=\"transparent\">
</object>}
  end
  
end