class StashYarnsController < ApplicationController
  before_action :set_stash_yarn, only: [:show, :edit, :update, :destroy]

  def index
    @stash_yarns = StashYarn.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @stash_yarn = StashYarn.new
    @yarn_products = YarnProduct.all.includes(:yarn_company)
  end

  def create
    @stash_yarn = StashYarn.new(stash_yarn_params)
    @stash_yarn.user = current_user

    if @stash_yarn.save
      redirect_to @stash_yarn
    else
      render :new
    end
  end

  def edit
    @yarn_products = YarnProduct.all.includes(:yarn_company)
  end

  def update
    if @stash_yarn.update(stash_yarn_params)
      redirect_to @stash_yarn
    else
      render :edit
    end
  end

  def destroy
    @stash_yarn.destroy
    redirect_to stash_yarns_url, notice: "#{@stash_yarn.name} was removed from your stash."
  end

  private

  def set_stash_yarn
    @stash_yarn = StashYarn.where(user_id: current_user.id).find(params[:id])
  end

  def stash_yarn_params
    params.require(:stash_yarn)
          .permit(:yarn_product_id, :colorway_id, :name, :handspun, :colorway_name, :purchase_date,
                  :purchased_at_name, :purchase_price, :skein_quantity, :total_yardage, :image,
                  :notes)
  end
end
