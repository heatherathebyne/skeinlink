class CraftersController < ApplicationController
  def show
    @crafter = User.find_by(id: params[:id])

    unless @crafter
      flash[:notice] = "We couldn't find that crafter."
      redirect_back(fallback_location: root_path)
      return
    end

    @latest_projects = @crafter.projects.newest.with_attached_images.limit(3)
  end

  def edit
    @crafter = current_user
  end

  def update
    @crafter = current_user
    if @crafter.update(crafter_params)
      redirect_to crafter_path(@crafter)
    else
      render :edit
    end
  end

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
      flash[:notice] = "There aren't any projects for that crafter."
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def autocomplete_project_name_for_current_user
    @projects = current_user.projects
                            .where("name LIKE ?", "%#{params[:name]}%")
                            .name_a_z
                            .limit(6)
    render :index
  end

  private

  def crafter_params
    params.require(:user).permit(:email, :name, :about_me)
  end

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
