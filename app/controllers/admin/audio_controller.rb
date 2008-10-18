class Admin::AudioController < Admin::AbstractModelController
  model_class Audio

  def index
    self.models = model_class.find(:all, :order => "position ASC")
  end

  def reorder
    @audio = Audio.find(:all, :order => 'position')
  end

  def update_order
    if request.post? && params.key?(:sort_order)
      list = params[:sort_order].split(',')
      list.size.times do |i|
        audio = Audio.find(list[i])
        audio.position = i + 1
        audio.save
      end
      redirect_to audio_index_url
    end
  end


end
