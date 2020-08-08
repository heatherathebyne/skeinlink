class CraftersController < ApplicationController
  def projects
    @projects = if params[:id].to_i == current_user.id
                  @project_user = current_user
                  current_user.projects
                              .public_send(sort_order_scope)
                              .with_attached_images
                              .page(params[:page])
                else
                  @project_user = User.find_by(id: params[:id])
                  Project.public_for_user(params[:id])
                         .public_send(sort_order_scope)
                         .with_attached_images
                         .page(params[:page])
                end

    unless @projects.any?
      flash[:notice] = "There aren't any projects for that user."
      redirect_back(fallback_location: root_path)
      return
    end
  end

  private

  def sort_order_scope
    case params[:sort]
    when 'newest'
      :newest
    when 'oldest'
      :oldest
    when 'name_a_z'
      :name_a_z
    when 'name_z_a'
      :name_z_a
    else
      :newest
    end
  end
end
