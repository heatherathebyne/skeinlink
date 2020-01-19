class ApplicationController < ActionController::Base
  require 'mini_magick'

  before_action :authenticate_user!
end
