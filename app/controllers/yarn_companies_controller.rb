class YarnCompaniesController < ApplicationController
  before_action :set_yarn_company, only: [:show, :edit, :update]

  def index
    @yarn_companies = YarnCompany.all.order(:name)
  end

  def show
  end

  def new
    @yarn_company = YarnCompany.new
  end

  def create
    @yarn_company = YarnCompany.new(yarn_company_params)

    if @yarn_company.save
      redirect_to @yarn_company
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @yarn_company.update(yarn_company_params)
      redirect_to @yarn_company
    else
      render :edit
    end
  end

  private

  def set_yarn_company
    @yarn_company = YarnCompany.find(params[:id])
  end

  def yarn_company_params
    params.require(:yarn_company).permit(:name)
  end
end
