class Admin::AudioPlayerConfigController < Admin::AbstractModelController
  model_class AudioPlayerConfig
  
  def index
    flash[:notice] = "Audio config settings saved."
    redirect_to :controller => :audio, :action => :index
  end
end