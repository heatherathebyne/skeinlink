class YarnDatabaseController < ApplicationController
  before_action :set_yarn_product, only: [:show, :edit, :update]

  def index
    @yarn_products = YarnProduct.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @yarn_product = YarnProduct.new
    @yarn_companies = YarnCompany.all
  end

  def create
    @yarn_product = YarnProduct.new(yarn_product_params)

    ImageAttachmentService.new(record: @yarn_product, images: yarn_product_image_params[:image]).call

    if @yarn_product.save
      redirect_to yarn_database_path(@yarn_product.id), notice: 'Yarn database entry added!'
    else
      render :new
    end
  end

  def edit
    @yarn_companies = YarnCompany.all
  end

  def update
    ImageAttachmentService.new(record: @yarn_product, images: yarn_product_image_params[:image]).call

    if @yarn_product.update(yarn_product_params)
      redirect_to yarn_database_path, id: @yarn_product.id, notice: 'Yarn database entry updated!'
    else
      render :new
    end
  end

  private

  def set_yarn_product
    @yarn_product = YarnProduct.includes(:yarn_company).find(params[:id])
  end

  def yarn_product_params
    params.require(:yarn_product)
          .permit(:name, :yarn_company_id, :skein_gram_weight, :skein_yards, :fiber_type_name,
                  :weight_name, :craft_yarn_council_weight, :weight_id, :description,
                  :referral_link, :referral_partner)
  end

  def yarn_product_image_params
    params.require(:yarn_product).permit(:image)
  end
end
