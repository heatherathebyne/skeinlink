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
    @project_user = if params[:id].to_i == current_user.id
      current_user
    else
      User.find_by(id: params[:id])
    end

    @q = @project_user.projects.ransack(params[:q])

    @projects = @q.result
                  .with_attached_images
                  .page(params[:page])

    unless @projects.any?
      flash[:notice] = "There aren't any projects for that crafter."
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def my_projects
    redirect_to projects_crafter_path(current_user)
    return
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
