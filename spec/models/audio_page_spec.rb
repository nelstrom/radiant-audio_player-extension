require File.dirname(__FILE__) + '/../spec_helper'

describe AudioPage do
  scenario :audio_page
  
  before(:each) do
    # @audio = Audio.new
    @audio_track = Audio.find(:first, :order => 'position ASC')
    @virtual_audio_page = Page.find_by_url("/audio/#{@audio_track.to_param}")
  end
  
  it "should find the audio listings page at /audio" do
    Page.find_by_url('/audio').should == pages(:audio)
  end
  
  it "should find the virtual audio page at /audio/id-slug" do
    # audio_track = Audio.find(:first, :order => 'position ASC')
    Page.find_by_url("/audio/#{@audio_track.to_param}").should == pages(:audio)
  end
  
  it "should be an index page at /audio" do
    Page.find_by_url('/audio').should render('<r:audio:if_index>YES!</r:audio:if_index>').as('YES!')
    Page.find_by_url('/audio').should render('<r:audio:unless_index>hidden</r:audio:unless_index>').as('')
  end
  it "should not be an index page at /audio/id-slug" do
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:audio:if_index>hidden</r:audio:if_index>').as('')
    Page.find_by_url("/audio/#{@audio_track.to_param}").should render('<r:audio:unless_index>YES!</r:audio:unless_index>').as('YES!')
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
  
  it "should show url with r:track:url" do
    @virtual_audio_page.should render('<r:track><r:url/></r:track>').
      as("/audio/#{@audio_track.id}/#{@audio_track.track_file_name}")
  end
  
  it "should show path with r:track:path" do
    @virtual_audio_page.should render('<r:track><r:path/></r:track>').as(@audio_track.path)
  end
  
  it "should output code for embedded player with r:track:player" do
    @virtual_audio_page.should render('<r:track><r:player/></r:track>').
      as(%Q{<object type=\"application/x-shockwave-flash\" data=\"/flash/audio_player/player.swf\" id=\"audioplayer350120067\" height=\"24\" width=\"290\">
<param name=\"movie\" value=\"/flash/audio_player/player.swf\">
<param name=\"FlashVars\" value=\"playerID=#{@audio_track.id}&amp;soundFile=/audio/#{@audio_track.id}/#{@audio_track.track_file_name}&amp;lefticon=0x666666&amp;autostart=no&amp;loader=0x9FFFB8&amp;text=0x666666&amp;track=0xFFFFFF&amp;border=0x666666&amp;slider=0x666666&amp;rightbg=0xcccccc&amp;leftbg=0xeeeeee&amp;bg=0xf8f8f8&amp;righticonhover=0xffffff&amp;loop=no&amp;rightbghover=0x999999&amp;righticon=0x666666\">
<param name=\"quality\" value=\"high\">
<param name=\"menu\" value=\"false\">
<param name=\"wmode\" value=\"transparent\">
</object>})
  end
  
end