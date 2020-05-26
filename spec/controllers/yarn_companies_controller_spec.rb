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
      let(:params) { build(:yarn_company, :with_optional_fields).attributes }

      before do
        sign_in user
        post :create, params: params
      end

      context 'when user is not authorized to create a yarn company' do
        let(:user) { create :user }

        it_behaves_like 'displays maintainer flash'

        it 'nopes out' do
          expect(response).to redirect_to root_path
        end
      end

      context 'when user is authorized to create a yarn company' do
        let(:user) { create :user, :maintainer }

        it 'saves the new yarn company with the expected attributes'

        it 'sets the id of the creating user'
      end
    end
  end
end
