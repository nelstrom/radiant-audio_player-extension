class AudioHelpersScenario < Scenario::Base
  uses :home_page
  
  helpers do
    def create_audio(title, attributes={})
      create_record :audio, title.symbolize, audio_params(
        attributes.reverse_merge(:title => title, :track_content_type => "audio/mpg")
      )
    end
    
    def audio_params(attributes={})
      title = attributes[:title] || unique_audio_title
      position = audio_track_position
      { 
        :title => title,
        :description => "Description of your audio track here",
        :position => position
      }.merge(attributes)
    end
    
    private
    @@no_of_audio_tracks = 0
    def audio_track_position
      @@no_of_audio_tracks += 1
    end
    
    @@unique_audio_title_call_count = 0
    def unique_audio_title
      @@unique_audio_title_call_count += 1
      "audio-#{@@unique_audio_title_call_count}"
    end
  end
end