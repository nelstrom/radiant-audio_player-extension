require File.dirname(__FILE__) + '/../spec_helper'

describe Audio do
  before(:each) do
    @audio = Audio.new
  end

  it "should be valid" do
    @audio.should be_valid
  end
end
