class ColorwaysController < ApplicationController
  include UpdateAttributionAction

  before_action :require_maintainer, :set_yarn_product
  before_action :set_colorway, only: [:edit, :update, :update_attribution]

  def create
    @colorway = Colorway.new(colorway_params)
    @colorway.yarn_product = @yarn_product
    authorize @colorway, :create?
    ImageAttachmentService.new(record: @colorway, images: colorway_image_params[:image]).call

    if @colorway.save
      redirect_to yarn_database_path(@yarn_product), notice: 'Colorway added!'
    else
      redirect_to yarn_database_path(@yarn_product), alert: "We're sorry, but we couldn't create that colorway: #{@colorway.errors.messages}"
    end
  end

  def edit
  end

  def update
    authorize @colorway, :update?
    ImageAttachmentService.new(record: @colorway, images: colorway_image_params[:image]).call

    if @colorway.update(colorway_params)
      redirect_to @yarn_product, notice: 'Colorway added!'
    else
      redirect_to @yarn_product, alert: "We're sorry, but we couldn't update that colorway."
    end
  end

  def update_attribution
    update_image_attribution @colorway.image
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
    @yarn_product = YarnProduct.includes(:yarn_company).find(params[:yarn_product_id])
  end
end
