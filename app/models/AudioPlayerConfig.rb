class AudioPlayerConfig < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :message => 'name already in use'
  
end