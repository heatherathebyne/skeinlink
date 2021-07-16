require 'rails_helper'

RSpec.describe ProjectsController do
  describe '#index' do
    let(:public_project) { create :project, :public }
    let(:private_project) { create :project, :private }

    context 'when user is not authenticated' do
      before { get :index }

      it 'returns only publicly visible projects' do
        expect(assigns[:projects]).to eq [public_project]
      end
    end

    context 'when user is authenticated' do
      let(:user) { create :user }

      before do
        sign_in user
        get :index
      end

      it 'returns all projects' do
        expect(assigns[:projects]).to include(public_project, private_project)
      end
    end
  end

  describe '#show' do
    shared_examples 'returns the project' do
      it do
        expect(assigns[:project]).to_not be_blank
      end
    end

    let(:public_project) { create :project, :public }
    let(:private_project) { create :project, :private }

    context 'when user is not authenticated' do
      context 'when project exists' do
        context 'when project is public' do
          before { get :show, params: { id: public_project.id } }
          it_behaves_like 'returns the project'
        end

        context 'when project is private' do
          before { get :show, params: { id: private_project.id } }
          it_behaves_like 'redirects to root path'
        end
      end

      context 'when project does not exist' do
        before { get :show, params: { id: -1 } }
        it_behaves_like 'redirects to root path'
      end
    end

    context 'when user is authenticated' do
      let(:user) { create :user }

      before { sign_in user }

      context 'when project exists' do
        context 'when project is public' do
          before { get :show, params: { id: public_project.id } }
          it_behaves_like 'returns the project'
        end

        context 'when project is private' do
          before { get :show, params: { id: private_project.id } }
          it_behaves_like 'returns the project'
        end
      end

      context 'when project does not exist' do
        before { get :show, params: { id: -1 } }
        it_behaves_like 'redirects to root path'
      end
    end
  end

  describe '#new' do
    context 'when user is not authenticated' do
      before { get :new }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
    end
  end

  describe '#edit' do
    context 'when user is not authenticated' do
      let(:project) { create :project }
      before { get :edit, params: { id: project.id } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
    end
  end

  describe '#create' do
    context 'when user is not authenticated' do
      before { post :create }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
    end
  end

  describe '#update' do
    context 'when user is not authenticated' do
      let(:project) { create :project }
      before { put :update, params: { id: project.id } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      context 'when project belongs to user' do
      end

      context 'when project does not belong to user' do
      end
    end
  end

  describe '#destroy' do
    context 'when user is not authenticated' do
    end

    context 'when user is authenticated' do
      context 'when project belongs to user' do
      end

      context 'when project does not belong to user' do
      end
    end
  end

  describe '#destroy_image' do
    context 'when user is not authenticated' do
    end

    context 'when user is authenticated' do
      context 'when project belongs to user' do
      end

      context 'when project does not belong to user' do
      end
    end
  end

  describe '#update_attribution' do
    context 'when user is not authenticated' do
    end

    context 'when user is authenticated' do
      context 'when project belongs to user' do
      end

      context 'when project does not belong to user' do
      end
    end
  end
end
