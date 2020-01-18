class ApplicationController < ActionController::Base
  require 'mini_magick'

  before_action :authenticate_user!

  private

  def process_original_image(image)
      MiniMagick::Image.new(image.tempfile.path) do |opt|
      opt.auto_orient
      opt.strip
      opt.resize '1280x1280>'
    end
  end
end
