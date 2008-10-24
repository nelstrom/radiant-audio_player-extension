class AudioPlayerConfig < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :message => 'name already in use'
  
  def parameters_for_player
    pa = []
    parameters.each do |key,value|
      pa << "#{key}=#{value}"
    end
    pa
  end
  
  def parameters
    cols = {}
    colors.each do |key|
      value = self.send(key)
      unless value.blank?
        cols[key] = value
      end
    end
    bools = {}
    bools[:loop] = (self.loop ? "yes" : "no")
    bools[:autostart] = (autostart ? "yes" : "no")
    cols.merge bools
  end
  
  def colors
    [ :bg, :leftbg, :lefticon, :rightbg, :rightbghover, :righticon, :righticonhover, :text, :slider, :track, :border, :loader ]
  end
  
end