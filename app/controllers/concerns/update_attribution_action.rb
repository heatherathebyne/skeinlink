module UpdateAttributionAction
  extend ActiveSupport::Concern

  private

  def update_image_attribution(image)
    head :not_found && return unless image
    if image.try(:update, attribution: params[:attribution])
      render plain: image.image_attribution
    else
      head :internal_server_error
    end
  end
end
