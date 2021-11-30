require 'rails_helper'

RSpec.describe StashUsagesController, type: :request do
  describe '#create' do
    subject { post '/stash_usages.json', params: params }
    let(:params) { {} }

    context 'when no user is logged in' do
      before { subject }
      it_behaves_like 'unauthorized response'
    end

    context 'when user is logged in' do
      # Scoping to current user is implicit. See StashUsagePolicy.
      let(:user) { create(:user) }
      let(:project) { create(:project, user: user) }
      let(:stash_yarn) { create(:stash_yarn, :with_name, user: user) }
      let(:params) do
        { stash_usage: { project_id: project.id, stash_yarn_id: stash_yarn.id, yards_used: 400 } }
      end

      before do
        sign_in user
        subject
      end

      it_behaves_like 'successful response'

      it 'creates a new stash usage with the specified yardage' do
        expect(project.stash_usages.find_by(stash_yarn: stash_yarn).yards_used).to eq 400
      end
    end
  end

  describe '#destroy' do
    subject { delete "/stash_usages.json", params: params }

    context 'when no user is logged in' do
      let(:params) { {} }
      before { subject }
      it_behaves_like 'unauthorized response'
    end

    context 'when user is logged in' do
      # Scoping to current user is implicit. See StashUsagePolicy.
      let(:user) { create(:user) }
      let(:project) { create(:project, user: user) }
      let(:stash_yarn) { create(:stash_yarn, :with_name, user: user) }

      before { sign_in user }

      context 'when stash usage exists' do
        let(:params) { { stash_usage: { project_id: project.id, stash_yarn_id: stash_yarn.id } } }
        let!(:existing_usage) do
          create :stash_usage, project: project, stash_yarn: stash_yarn, yards_used: 200
        end

        before { subject }

        it_behaves_like 'successful response'

        it 'removes the stash usage' do
          expect{ existing_usage.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when stash usage does not exist' do
        let(:params) { { stash_usage: { project_id: project.id, stash_yarn_id: stash_yarn.id } } }

        before { subject }

        it_behaves_like 'successful response'
      end
    end
  end
end
