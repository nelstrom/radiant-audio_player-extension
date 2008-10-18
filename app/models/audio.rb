class Audio < ActiveRecord::Base
  has_attached_file :track,
    :url => "/:class/:id/:basename.:extension",
    :path => ":rails_root/public/:class/:id/:basename.:extension"
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  validates_presence_of :title
  validates_uniqueness_of :title, :message => 'name already in use'
  validates_format_of :track_content_type, 
                      :with => /audio\/mpg/,
                      :message => "must be mp3"
end
