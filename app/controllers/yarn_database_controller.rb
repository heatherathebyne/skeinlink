class YarnDatabaseController < ApplicationController
  include UpdateAttributionAction

  before_action :set_yarn_product, only: [:show, :edit, :update, :update_attribution]

  def index
    @yarn_products = YarnProduct.all
                                .public_send(sort_order_scope)
                                .includes(:yarn_company)
                                .with_attached_image
                                .page(params[:page])
  end

  def show
  end

  def new
    @yarn_product = YarnProduct.new
    @yarn_companies = YarnCompany.all
  end

  def create
    @yarn_product = YarnProduct.new(yarn_product_params)
    @yarn_product.created_by = current_user.id

    authorize @yarn_product, :create?

    ImageAttachmentService.call(record: @yarn_product, images: yarn_product_image_params[:image])

    @yarn_product.fiber_content_list = filtered_fiber_content_tags

    respond_to do |format|
      format.html do
        if @yarn_product.save
          redirect_to @yarn_product, notice: 'Yarn database entry added!'
        else
          @yarn_companies = YarnCompany.all
          render :new
        end
      end
      format.js do
        if @yarn_product.save
          render status: :ok, json: { id: @yarn_product.id, name: @yarn_product.name }
        else
          render status: :not_acceptable, json: { errors: @yarn_product.errors.full_messages }
        end
      end
    end
  end

  def edit
    authorize @yarn_product, :update?
    @yarn_companies = YarnCompany.all
  end

  def update
    authorize @yarn_product, :update?

    ImageAttachmentService.call(record: @yarn_product, images: yarn_product_image_params[:image])

    @yarn_product.fiber_content_list = filtered_fiber_content_tags

    if @yarn_product.update(yarn_product_params)
      redirect_to @yarn_product, notice: 'Yarn database entry updated!'
    else
      @yarn_companies = YarnCompany.all
      render :edit
    end
  end

  def update_attribution
    authorize @yarn_product, :update?
    update_image_attribution @yarn_product.image
  end

  def autocomplete_name
    @yarn_products = YarnProduct.where(yarn_company_id: params[:id])
                                .where("name LIKE ?", "%#{params[:name]}%").limit(6)
    render :index
  end

  def autocomplete_name_for_stash
    @yarn_products = YarnProduct.where(yarn_company_id: params[:id])
      .where("name LIKE ?", "%#{params[:name]}%").limit(6).order(name: :asc).to_a
    @yarn_products << YarnProduct.new(id: -3, name: 'Tell us about another yarn')
    render :index
  end

  private

  def set_yarn_product
    @yarn_product = YarnProduct.includes(:yarn_company).find(params[:id])
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

  def yarn_product_params
    permitted = [:name, :yarn_company_id, :skein_gram_weight, :skein_yards, :fiber_type_name,
                 :weight_name, :craft_yarn_council_weight, :weight_id, :description]
    permitted.concat [:referral_link, :referral_partner] if policy(YarnProduct).edit_referral_links?
    params.require(:yarn_product).permit(permitted)
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
