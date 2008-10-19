module AudioTags
  include Radiant::Taggable
  
  desc %{The namespace for all audio tags}
  tag 'audio' do |tag|
    tag.expand
  end
end