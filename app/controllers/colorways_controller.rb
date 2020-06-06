class ColorwaysController < ApplicationController
  include UpdateAttributionAction

  before_action :set_yarn_product
  before_action :set_colorway, only: [:edit, :update, :update_attribution]

  def index
    @colorways = @yarn_product.colorways
  end

  def create
    @colorway = Colorway.new(colorway_params)
    @colorway.yarn_product = @yarn_product
    @colorway.created_by = current_user.id

    authorize @colorway, :create?

    ImageAttachmentService.call(record: @colorway, images: colorway_image_params[:image])

    respond_to do |format|
      format.html do
        if @colorway.save
          redirect_to @yarn_product, notice: 'Colorway added!'
        else
          redirect_to @yarn_product, alert: "We're sorry, but we couldn't create that colorway: #{@colorway.errors.messages}"
        end
      end

      format.js do
        if @colorway.save
          render status: :ok, json: { id: @colorway.id, name_with_number: @colorway.name_with_number }
        else
          render status: :not_acceptable, json: { errors: @colorway.errors.full_messages }
        end
      end
    end
  end

  def edit
  end

  def update
    authorize @colorway, :update?
    ImageAttachmentService.call(record: @colorway, images: colorway_image_params[:image])

    if @colorway.update(colorway_params)
      redirect_to @yarn_product, notice: 'Colorway added!'
    else
      redirect_to @yarn_product, alert: "We're sorry, but we couldn't update that colorway."
    end
  end

  def update_attribution
    authorize @colorway, :update?
    update_image_attribution @colorway.image
  end

  def autocomplete_name_or_number
    @colorways = Colorway.where(yarn_product_id: params[:yarn_product_id])
                         .where("name LIKE ? OR number LIKE ?",
                                "%#{params[:term]}%",
                                "%#{params[:term]}%")
                         .limit(6)
    render :index
  end

  def autocomplete_name_or_number_for_stash
    @colorways = Colorway.where(yarn_product_id: params[:yarn_product_id])
                         .where("name LIKE ? OR number LIKE ?",
                                "%#{params[:term]}%",
                                "%#{params[:term]}%")
                                  .limit(6).order(name: :asc).to_a
    @colorways << Colorway.new(id: -3, name: 'Tell us about another colorway', number: '')
    render :index
  end

  private

  def colorway_params
    params.require(:colorway).permit(:name, :number)
  end

  def colorway_image_params
    params.require(:colorway).permit(:image)
  end

  def set_colorway
    @colorway = Colorway.find(params[:id])
  end

  def set_yarn_product
    yarn_product_id = params[:yarn_product_id] || params[:colorway][:yarn_product_id]
    @yarn_product = YarnProduct.includes(:yarn_company).find(yarn_product_id || nil)
  end
end
