class StashYarnsController < ApplicationController
  include UpdateAttributionAction

  before_action :set_stash_yarn, only: [:edit, :update, :update_attribution, :destroy]

  def index
    @stash_yarns = StashYarn.where(user_id: current_user.id)
                        .includes(:colorway)
                        .with_attached_image
                        .public_send(sort_order_scope)
                        .page(params[:page])
  end

  def show
    @stash_yarn = StashYarn.where(user_id: current_user.id)
                           .includes(yarn_product: :yarn_company)
                           .includes(stash_usages: :project)
                           .find(params[:id])
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

  def autocomplete_name
    # can search by yarn maker name plus yarn name, or makerless yarn name:
    # Cascade Yarns Cascade 220
    # or
    # My Own Handspun
    #
    # Note to implementers:
    # Come back after you've satisfactorily designed a workflow for searching
    # "cascade pima rose"
    # and retrieving the YarnProduct and Colorway for Cascade Yarns Ultra Pima Fine,
    # colorway 3840 Veiled Rose.
    # That's why there's nothing here right now, and we search for projects from our stash yarn.
  end

  private

  def set_stash_yarn
    @stash_yarn = StashYarn.where(user_id: current_user.id)
                           .includes(yarn_product: :yarn_company)
                           .find(params[:id])
  end

  def sort_order_scope
    case params[:sort]
    when 'newest'
      :newest
    when 'oldest'
      :oldest
    when 'yarn_a_z'
      :yarn_name_a_z
    when 'yarn_z_a'
      :yarn_name_z_a
    when 'maker_a_z'
      :yarn_maker_name_a_z
    when 'maker_z_a'
      :yarn_maker_name_z_a
    else
      :newest
    end
  end

  def stash_yarn_params
    params.require(:stash_yarn)
          .permit(:yarn_product_id, :colorway_id, :name, :handspun, :colorway_name, :purchase_date,
                  :purchased_at_name, :purchase_price, :skein_quantity, :total_yardage,
                  :notes, :weight_id, :other_maker_type, :dye_lot)
  end

  def stash_yarn_image_params
    params.require(:stash_yarn).permit(:image)
  end
end
