require 'rails_helper'

RSpec.describe CraftersController do
  describe '#show' do
    context 'when user is not authenticated' do
      before { get :show, params: { id: 12345 } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      before { sign_in user }

      context 'when crafter exists' do
        let(:crafter) { create :user, :crafter }
        before do
          create_list(:project, 4, user: crafter)
          get :show, params: { id: crafter.id }
        end

        it 'finds crafter and latest projects' do
          expect(assigns[:crafter]).to eq crafter
          expect(assigns[:latest_projects].count).to eq 3
          expect(assigns[:latest_projects].map(&:user_id).uniq).to eq [crafter.id]
        end
      end

      context 'when crafter does not exist' do
        before { get :show, params: { id: 12345 } }
        it_behaves_like 'redirects to root path'
      end
    end
  end

  describe '#edit' do
    context 'when user is not authenticated' do
      before { get :edit, params: { id: 12345 } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:other_user) { create :user }
      before do
        sign_in user
        get :edit, params: { id: other_user.id }
      end

      it 'always finds the current user' do
        expect(assigns[:crafter]).to eq user
      end
    end
  end

  describe '#update' do
    context 'when user is not authenticated' do
      before { patch :update, params: { id: 12345 } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:other_user) { create :user }

      before do
        sign_in user
      end

      it 'always updates the current user' do
        patch :update, params: { id: other_user.id, user: { name: 'not my account' } }
        expect(user.reload.name).to eq 'not my account'
        expect(other_user.reload.name).to_not eq 'not my account'
      end

      context 'when update is successful' do
        it 'redirects to crafter profile' do
          patch :update, params: { id: user.id, user: { name: 'updated' } }
          expect(response).to redirect_to crafter_path(user)
        end
      end
    end
  end

  describe '#projects' do
  end
end
