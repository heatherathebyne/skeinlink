class ApplicationController < ActionController::Base
  require 'mini_magick'
  include Pundit

  before_action :authenticate_user!
end
