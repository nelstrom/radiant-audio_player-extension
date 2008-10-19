require File.dirname(__FILE__) + '/../spec_helper'

describe Audio do
  scenario :audio_page
  
  it "should use id and title to form a slug" do
    @audio_track = Audio.find_by_title("Debut")
    @audio_track.path.should == "/audio/#{@audio_track.id}-debut"
    @audio_track = Audio.find_by_title("Mostly harmless")
    @audio_track.path.should == "/audio/#{@audio_track.id}-mostly-harmless"
  end
  
end
