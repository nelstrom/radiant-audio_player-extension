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


  protected
  
  def handle_new_or_edit_post(options = {})
    options.symbolize_keys
    debugger
    if request.post?
      model.attributes = params[model_symbol]
      begin
        if save
          clear_model_cache
          announce_saved(options[:saved_message])
          redirect_to continue_url(options)
          return false
        else
          announce_validation_errors
        end
      rescue ActiveRecord::StaleObjectError
        announce_update_conflict
      end
    end
    true
  end

end
