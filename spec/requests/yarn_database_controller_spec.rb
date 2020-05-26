require 'rails_helper'

RSpec.describe YarnDatabaseController, type: :request do
  describe '#show' do
    subject { get "/yarn_database/#{yarn_product.id}" }
    let!(:yarn_product) { create(:yarn_product) }

    context 'when no user is logged in' do
      before { subject }
      it_behaves_like 'redirects to login'
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }
      before { sign_in user; subject }
      it_behaves_like 'successful response'
    end
  end

  describe '#new' do
    subject { get '/yarn_database/new', headers: { HTTP_REFERER: projects_path } }

    context 'when user is not logged in' do
      before { subject }
      it_behaves_like 'redirects to login'
    end

    context 'when user is logged in' do
      before { sign_in user; subject }

      context 'when user is a maintainer' do
        let(:user) { create(:user, :maintainer) }
        it_behaves_like 'successful response'
      end

      context 'when user is not a maintainer' do
        let(:user) { create(:user) }
        it_behaves_like 'redirects to root path'
      end
    end
  end

  describe '#create' do
    subject { post '/yarn_database', params: params, headers: { HTTP_REFERER: projects_path } }
    let(:params) { {} }

    context 'when user is logged in' do
      before { sign_in user }

      context 'when user is a maintainer' do
        let(:user) { create(:user, :maintainer) }

        context 'when providing good params' do
          let(:params) { { yarn_product: { yarn_company_id: 1, name: 'some yarn name' } } }

          it 'creates a new yarn product' do
            expect{ subject }.to change(YarnProduct, :count).by 1
          end
        end

        context 'when providing bad params' do
          let(:params) { { yarn_product: { yarn_company_id: 1 } } }

          it 'does not create a new yarn product' do
            expect{ subject }.to_not change(YarnProduct, :count)
          end
        end
      end
    end
  end

  describe '#update' do
    subject { patch "/yarn_database/#{yarn_product.id}", params: params, headers: { HTTP_REFERER: projects_path } }
    let!(:yarn_product) { create(:yarn_product) }
    let(:params) { {} }

    context 'when user is not logged in' do
      before { subject }
      it_behaves_like 'redirects to login'
    end

    context 'when user is logged in' do
      before { sign_in user; subject }

      context 'when user is a maintainer' do
        let(:user) { create(:user, :maintainer) }

        context 'when providing good params' do
          let(:params) { { yarn_product: { yarn_company_id: 1, name: 'some other yarn name' } } }

          it 'updates the yarn product' do
            expect(yarn_product.reload.name).to eq 'some other yarn name'
          end
        end

        context 'when providing bad params' do
          let(:params) { { yarn_product: { yarn_company_id: 1, name: '' } } }

          it 'does not update the yarn product' do
            expect(yarn_product.reload.name).to_not eq 'some other yarn name'
          end
        end
      end

      context 'when user is not a maintainer' do
        before { subject }
        let(:user) { create(:user) }
        it_behaves_like 'redirects to root path'
      end
    end
  end
end
