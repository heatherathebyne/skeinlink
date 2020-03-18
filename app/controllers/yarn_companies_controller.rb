class YarnCompaniesController < ApplicationController
  before_action :set_yarn_company, only: [:show, :edit, :update]
  before_action :require_maintainer, only: [:new, :create, :edit, :update]

  def index
    @yarn_companies = YarnCompany.all.order(:name).page(params[:page])
  end

  def show
  end

  def new
    @yarn_company = YarnCompany.new
  end

  def create
    @yarn_company = YarnCompany.new(yarn_company_params)
    authorize @yarn_company, :create?

    if @yarn_company.save
      redirect_to @yarn_company
    else
      render :new
    end
  end

  def edit
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
    render json: YarnCompany.where("name LIKE ?", "%#{params[:name]}%").limit(10)
  end

  private

  def set_yarn_company
    @yarn_company = YarnCompany.find(params[:id])
  end

  def yarn_company_params
    params.require(:yarn_company).permit(:name, :website, :referral_link, :description, :referral_partner)
  end
end
