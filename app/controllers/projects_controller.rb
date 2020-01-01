class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy, :destroy_image]
  skip_before_action :authenticate_user!, only: [:index, :show]

  # GET /projects
  # GET /projects.json
  def index
    if user_signed_in?
      @projects = Project.all.order(id: :desc)
    else
      @projects = Project.where(publicly_visible: true).order(id: :desc)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if user_signed_in?
      @project = Project.find(params[:id])
    else
      @project = Project.where(publicly_visible: true).find_by(id: params[:id])
    end

    unless @project
      flash[:notice] = "That project isn't public, or it doesn't exist."
      redirect_back(fallback_location: root_path)
      return
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    @project.images = project_images_params

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    project_images_params[:images].each do |image|
      @project.images.attach image
    end if project_images_params[:images]

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_image
    image = @project.images.find(params[:image_id])
    head :not_found unless image
    head :ok if image.try(:destroy)
    head :internal_server_error
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :craft_id, :name, :pattern_name, :status_name, :notes, :private_notes, :tools_freetext,
        :publicly_visible
      )
    end

    def project_images_params
      params.require(:project).permit(images: [])
    end
end
