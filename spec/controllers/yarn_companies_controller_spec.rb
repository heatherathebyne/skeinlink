require 'rails_helper'

RSpec.describe YarnCompaniesController do
  describe '#index' do
    context 'when user is not authenticated' do
      before { get :index }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:yarn_company) { create :yarn_company }

      before do
        sign_in user
        get :index
      end

      it_behaves_like 'successful response'

      it 'returns yarn companies' do
        expect(assigns[:yarn_companies]).to include yarn_company
      end
    end
  end

  describe '#create' do
    context 'when user is not authenticated' do
      before { post :create }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:yarn_company_attrs) do
        build(:yarn_company, :with_optional_fields)
          .attributes
          .slice('name', 'website', 'referral_link', 'description', 'referral_partner')
      end

      before do
        sign_in user
        post :create, params: { yarn_company: yarn_company_attrs }
      end

      context 'when user is not authorized to create a yarn company' do
        let(:user) { create :user }

        it_behaves_like 'displays maintainer flash'
        it_behaves_like 'redirects to root path'
      end

      context 'when user is authorized to create a yarn company' do
        let(:user) { create :user, :maintainer }

        # implicit 'redirects to the new yarn company'

        it 'creates the new yarn company with the expected attributes' do
          expect(assigns[:yarn_company].attributes).to include(yarn_company_attrs)
        end

        it 'sets the id of the creating user' do
          expect(assigns[:yarn_company].created_by).to eq user.id
        end
      end
    end
  end
end
