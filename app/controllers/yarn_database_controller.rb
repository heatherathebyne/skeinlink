class YarnDatabaseController < ApplicationController
  before_action :set_yarn_product, only: [:show, :edit, :update]

  def index
    @yarn_products = YarnProduct.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @yarn_product = YarnProduct.new
  end

  def create
    @yarn_product = YarnProduct.new(yarn_product_params)

    if @yarn_product.save
      redirect_to :show, id: @yarn_product.id, notice: 'Yarn database entry added!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @yarn_product.update(yarn_product_params)
      redirect_to :show, id: @yarn_product.id, notice: 'Yarn database entry updated!'
    else
      render :new
    end
  end

  private

  def set_yarn_product
    @yarn_product = YarnProduct.find(params[:id])
  end

  def yarn_product_params
  end
end
