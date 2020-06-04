class StashYarnsController < ApplicationController
  include UpdateAttributionAction

  before_action :set_stash_yarn, only: [:show, :edit, :update, :update_attribution, :destroy]

  def index
    @stash_yarns = StashYarn.where(user_id: current_user.id).order(:yarn_product_id).page(params[:page])

  end

  def show
  end

  def new
    @stash_yarn = StashYarn.new
    if params[:new_form]
      render :new_new
    else
      render :new
    end
  end

  def create
    @stash_yarn = StashYarn.new(stash_yarn_params)
    @stash_yarn.user = current_user

    ImageAttachmentService.new(record: @stash_yarn, images: stash_yarn_image_params[:image]).call

    if @stash_yarn.save
      redirect_to stash_yarns_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    ImageAttachmentService.new(record: @stash_yarn, images: stash_yarn_image_params[:image]).call

    if @stash_yarn.update(stash_yarn_params)
      redirect_to @stash_yarn
    else
      render :edit
    end
  end

  def update_attribution
    update_image_attribution @stash_yarn.image
  end

  def destroy
    @stash_yarn.destroy
    redirect_to stash_yarns_url, notice: "#{@stash_yarn.name} was removed from your stash."
  end

  private

  def set_stash_yarn
    @stash_yarn = StashYarn.where(user_id: current_user.id)
                           .includes(yarn_product: :yarn_company)
                           .find(params[:id])
  end

  def stash_yarn_params
    params.require(:stash_yarn)
          .permit(:yarn_product_id, :colorway_id, :name, :handspun, :colorway_name, :purchase_date,
                  :purchased_at_name, :purchase_price, :skein_quantity, :total_yardage,
                  :notes, :weight_id, :other_maker_type)
  end

  def stash_yarn_image_params
    params.require(:stash_yarn).permit(:image)
  end
end
