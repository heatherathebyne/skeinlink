class CraftersController < ApplicationController
  def projects
    @projects = if params[:id].to_i == current_user.id
                  @project_user = current_user
                  current_user.projects
                else
                  @project_user = User.find_by(id: params[:id])
                  Project.public_for_user(params[:id])
                end

    unless @projects.any?
      flash[:notice] = "There aren't any projects for that user."
      redirect_back(fallback_location: root_path)
      return
    end
  end
end
