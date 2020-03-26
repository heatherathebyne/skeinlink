class YarnDatabaseController < ApplicationController
  include UpdateAttributionAction

  before_action :set_yarn_product, only: [:show, :edit, :update, :update_attribution]
  before_action :require_maintainer, only: [:new, :create, :edit, :update, :update_attribution]

  def index
    @yarn_products = YarnProduct.all.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @yarn_product = YarnProduct.new
    @yarn_companies = YarnCompany.all
  end

  def create
    @yarn_product = YarnProduct.new(yarn_product_params)
    authorize @yarn_product, :create?

    ImageAttachmentService.new(record: @yarn_product, images: yarn_product_image_params[:image]).call

    @yarn_product.fiber_content_list = filtered_fiber_content_tags

    if @yarn_product.save
      redirect_to @yarn_product, notice: 'Yarn database entry added!'
    else
      @yarn_companies = YarnCompany.all
      render :new
    end
  end

  def edit
    @yarn_companies = YarnCompany.all
  end

  def update
    authorize @yarn_product, :update?

    ImageAttachmentService.new(record: @yarn_product, images: yarn_product_image_params[:image]).call

    @yarn_product.fiber_content_list = filtered_fiber_content_tags

    if @yarn_product.update(yarn_product_params)
      redirect_to @yarn_product, notice: 'Yarn database entry updated!'
    else
      @yarn_companies = YarnCompany.all
      render :edit
    end
  end

  def update_attribution
    update_image_attribution @yarn_product.image
  end

  def autocomplete_name
    @yarn_products = YarnProduct.where(yarn_company_id: params[:id])
                                .where("name LIKE ?", "%#{params[:name]}%").limit(6)
    render :index
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

  def filtered_fiber_content_tags
    tags = params[:fiber_content_tags]
    return if tags.blank?
    JSON.parse(params[:fiber_content_tags]) & FIBER_TYPES.flatten(2)
  end
end
