require 'rails_helper'

RSpec.describe ProjectsController do
  shared_examples 'returns the project' do
    it do
      expect(assigns[:project]).to_not be_blank
    end
  end

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
      let(:user) { create :user }

      before do
        sign_in user
        get :new
      end

      it_behaves_like 'returns the project'
    end
  end

  describe '#edit' do
    context 'when user is not authenticated' do
      let(:project) { create :project }
      before { get :edit, params: { id: project.id } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }

      before { sign_in user }

      context 'when project belongs to user' do
        let(:their_project) { create :project, :public, user: user }
        before { get :edit, params: { id: their_project.id } }
        it_behaves_like 'returns the project'
      end

      context 'when project does not belong to user' do
        let(:not_their_project) { create :project, :public, user: create(:user) }
        before { get :edit, params: { id: not_their_project.id } }
        it_behaves_like 'redirects to root path'
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
      let(:sample_image_data) { fixture_file_upload file_fixture('images/jpg-test-1.jpg') }

      before { sign_in user }

      context 'when user submits valid params' do
        let(:project_attrs) do
          build(:project, :public, user: user, name: SecureRandom.hex(8),
                status_name: 'Initial Optimism').attributes
        end
        let(:project) { Project.find_by(name: project_attrs['name']) }

        before do
          allow(ImageAttachmentService).to receive(:call)
          post :create, params: { project: project_attrs.merge(images: [sample_image_data]) }
        end

        it 'redirects to the new project' do
          expect(response).to redirect_to project_path(project)
        end

        it 'creates the new project with the expected attributes' do
          expect(project.status_name).to eq 'Initial Optimism'
          expect(project.user).to eq user
        end

        it 'attaches the uploaded image' do
          expect(ImageAttachmentService).to have_received(:call).with(hash_including(
            images: [kind_of(ActionDispatch::Http::UploadedFile)], record: kind_of(Project)
          ))
        end
      end

      context 'when user submits invalid params' do
        let(:project_attrs) do
          build(:project, :public, user: user, craft_id: 47).attributes
        end
        let(:create_request) { post :create, params: { project: project_attrs } }

        it 'does not create a new project' do
          expect{ create_request }.to_not change{ Project.count }
        end

        it 'renders the :new template' do
          create_request
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe '#update' do
    context 'when user is not authenticated' do
      let(:project) { create :project }
      before { put :update, params: { id: project.id } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:sample_image_data) { fixture_file_upload file_fixture('images/jpg-test-1.jpg') }

      before { sign_in user }

      context 'when project belongs to user' do
        let(:project) { create :project, :public, user: user, name: SecureRandom.hex(8) }

        context 'when user submits valid params' do
          let(:updated_project_params) { { name: 'Overly Ambitious', images: [sample_image_data] } }

          before do
            allow(ImageAttachmentService).to receive(:call)
            put :update, params: { id: project.id, project: updated_project_params }
          end

          it 'redirects to the project' do
            expect(response).to redirect_to project_path(project)
          end

          it 'updates the project with the expected attributes' do
            expect(project.reload.name).to eq 'Overly Ambitious'
          end

          it 'attaches the uploaded image' do
            expect(ImageAttachmentService).to have_received(:call).with(hash_including(
              images: [kind_of(ActionDispatch::Http::UploadedFile)], record: kind_of(Project)
            ))
          end
        end

        context 'when user submits invalid params' do
          let(:updated_project_params) { { craft_id: 47 } }

          before { put :update, params: { id: project.id, project: updated_project_params } }

          it 'does not update the project' do
            expect(project.reload.craft_id).to eq project.craft_id
          end

          it 'renders the :edit template' do
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'when project does not belong to user' do
        let(:project) { create :project, :public, user: create(:user) }
        let(:updated_project_params) { { name: 'Ugly Baby' } }

        before do
          put :update, params: { id: project.id, project: updated_project_params }
        rescue ActiveRecord::RecordNotFound
        end

        it 'does not update the project' do
          expect(project.reload.name).to_not eq 'Ugly Baby'
        end
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
