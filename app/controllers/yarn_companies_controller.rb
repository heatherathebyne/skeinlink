class YarnCompaniesController < ApplicationController
  before_action :set_yarn_company, only: [:edit, :update]

  def index
    @yarn_companies = YarnCompany.all.order(:name).page(params[:page])
  end

  def show
    @yarn_company = YarnCompany.includes(yarn_products: :image_attachment).find(params[:id])
  end

  def new
    @yarn_company = YarnCompany.new
  end

  def create
    @yarn_company = YarnCompany.new(yarn_company_params)
    @yarn_company.created_by = current_user.id

    authorize @yarn_company, :create?

    respond_to do |format|
      format.html do
        if @yarn_company.save
          redirect_to @yarn_company
        else
          render :new
        end
      end
      format.js do
        if @yarn_company.save
          render status: :ok, json: { id: @yarn_company.id, name: @yarn_company.name }
        else
          render status: :not_acceptable, json: { errors: @yarn_company.errors.full_messages }
        end
      end
    end
  end

  def edit
    authorize @yarn_company, :update?
  end

  def update
    authorize @yarn_company, :update?
    if @yarn_company.update(yarn_company_params)
      redirect_to @yarn_company
    else
      render :edit
    end
  end

  def autocomplete_name
    @yarn_companies = YarnCompany.where("name LIKE ?", "%#{params[:name]}%").limit(6)
    render :index
  end

  def autocomplete_name_for_stash
    @yarn_companies = YarnCompany.where("name LIKE ?", "%#{params[:name]}%").limit(6).order(name: :asc).to_a
    @yarn_companies << YarnCompany.new(id: -3, name: 'Tell us about another yarn maker')
    @yarn_companies << YarnCompany.new(id: -1, name: 'I made this yarn')
    @yarn_companies << YarnCompany.new(id: -2, name: "I don't know who made this yarn")
    render :index
  end

  private

  def set_yarn_company
    @yarn_company = YarnCompany.find(params[:id])
  end

  def yarn_company_params
    permitted = [:name, :website, :description]
    permitted.concat [:referral_link, :referral_partner] if policy(YarnCompany).edit_referral_links?
    params.require(:yarn_company).permit(permitted)
  end
end
