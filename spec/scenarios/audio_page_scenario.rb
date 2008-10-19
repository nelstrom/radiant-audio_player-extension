class AudioPageScenario < Scenario::Base
  uses :audio_helpers
  
  def load
    create_page "Audio",  :class_name => "AudioPage"
    
    create_audio "Debut", :description => "Her first recording."
    create_audio "Mostly harmless", :description => "Fourth in the trilogy"
  end
  
end