require File.dirname(__FILE__) + '/../spec_helper'

describe AudioPage do
  scenario :audio_page
  
  it "should find the audio listings page at /audio" do
    Page.find_by_url('/audio').should == pages(:audio)
  end
  
  it "should find the virtual audio page at /audio/id-slug" do
    audio_track = Audio.find(:first, :order => 'position ASC')
    Page.find_by_url("/audio/#{audio_track.to_param}").should == pages(:audio)
  end
  
  it "should be an index page at /audio" do
    Page.find_by_url('/audio').should render('<r:audio:if_index>YES!</r:audio:if_index>').as('YES!')
    Page.find_by_url('/audio').should render('<r:audio:unless_index>hidden</r:audio:unless_index>').as('')
  end
  it "should not be an index page at /audio/id-slug" do
    audio_track = Audio.find(:first, :order => "position ASC")
    Page.find_by_url("/audio/#{audio_track.to_param}").should render('<r:audio:if_index>hidden</r:audio:if_index>').as('')
    Page.find_by_url("/audio/#{audio_track.to_param}").should render('<r:audio:unless_index>YES!</r:audio:unless_index>').as('YES!')
  end
  
end