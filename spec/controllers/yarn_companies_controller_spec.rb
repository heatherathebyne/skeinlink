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
      let(:user) { create :user }
      let(:yarn_company_attrs) do
        build(:yarn_company, :with_optional_fields)
          .attributes
          .slice('name', 'website', 'referral_link', 'description', 'referral_partner')
      end

      before do
        allow(YarnCompanyPolicy).to receive(:new).and_return(
          instance_double 'YarnCompanyPolicy', create?: permit, edit_referral_links?: permit_referral
        )
        sign_in user
        post :create, params: { yarn_company: yarn_company_attrs }
      end

      context 'when user is not authorized to create a yarn company' do
        let(:permit) { false }
        let(:permit_referral) { false }

        it_behaves_like 'displays unauthorized flash'
        it_behaves_like 'redirects to root path'
      end

      context 'when user is authorized to create a yarn company' do
        let(:permit) { true }
        let(:yarn_company) { YarnCompany.find_by(name: yarn_company_attrs['name']) }

        context 'when user is not authorized to create referral links' do
          let(:permit_referral) { false }

          it 'redirects to new yarn company' do
            expect(response).to redirect_to yarn_company_path(yarn_company)
          end

          it 'creates the new yarn company with the expected attributes' do
            expect(yarn_company.attributes).to include(yarn_company_attrs.reject { |k,v| k =~ /referral/ })
            expect(yarn_company.created_by).to eq user.id
            expect(yarn_company.referral_link).to_not eq yarn_company_attrs['referral_link']
          end
        end

        context 'when user is authorized to create referral links' do
          let(:permit_referral) { true }

          it 'redirects to new yarn company' do
            expect(response).to redirect_to yarn_company_path(yarn_company)
          end

          it 'creates the new yarn company with the expected attributes' do
            expect(yarn_company.attributes).to include(yarn_company_attrs)
            expect(yarn_company.created_by).to eq user.id
          end
        end
      end
    end
  end

  describe '#update' do
    context 'when user is not authenticated' do
      before { patch :update, params: { id: 1 } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:yarn_company) { create :yarn_company }

      before do
        allow(YarnCompanyPolicy).to receive(:new).and_return(
          instance_double 'YarnCompanyPolicy', update?: permit, edit_referral_links?: permit_referral
        )
        sign_in user
        patch :update, params: { id: yarn_company.id, yarn_company: {
          name: 'Local Farm', referral_link: 'some yarn store' } }
        yarn_company.reload
      end

      context 'when user is not authorized to update a yarn company' do
        let(:permit) { false }
        let(:permit_referral) { false }

        it_behaves_like 'displays unauthorized flash'
        it_behaves_like 'redirects to root path'
      end

      context 'when user is authorized to update a yarn company' do
        let(:permit) { true }

        context 'when user is not authorized to update referral links' do
          let(:permit_referral) { false }

          it 'redirects to the yarn company' do
            expect(response).to redirect_to yarn_company_path(yarn_company)
          end

          it 'updates the yarn company with the expected attributes' do
            expect(yarn_company.name).to eq 'Local Farm'
            expect(yarn_company.referral_link).to_not eq 'some yarn store'
          end
        end

        context 'when user is authorized to update referral links' do
          let(:permit_referral) { true }

          it 'redirects to the yarn company' do
            expect(response).to redirect_to yarn_company_path(yarn_company)
          end

          it 'updates the yarn company with the expected attributes' do
            expect(yarn_company.name).to eq 'Local Farm'
            expect(yarn_company.referral_link).to eq 'some yarn store'
          end
        end
      end
    end
  end
end
