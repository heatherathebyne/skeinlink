require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  before { sign_in user }

  describe '#index' do
    before { get admin_users_path }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      it 'lists users' do
        expect(response.body).to include(user.email)
      end
    end

    context 'when user is not an admin' do
      let(:user) { create(:user) }

      it 'redirects back' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#show' do
  end

  describe '#new' do
  end

  describe '#create' do
  end

  describe '#update' do
  end

  describe '#enable' do
  end

  describe '#disable' do
  end
end
