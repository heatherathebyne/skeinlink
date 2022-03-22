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
    subject { delete "/stash_usages/#{stash_usage_id}.json" }

    context 'when no user is logged in' do
      let(:stash_usage_id) { -1 }
      before { subject }
      it_behaves_like 'unauthorized response'
    end

    context 'when user is logged in' do
      # Scoping to current user is implicit. See StashUsagePolicy.
      let(:user) { create(:user) }
      let(:project) { create(:project, user: user) }
      let(:someone_elses_project) { create(:project, user: create(:user)) }
      let(:stash_yarn) { create(:stash_yarn, :with_name, user: user) }

      before { sign_in user }

      context 'when stash usage exists' do
        before { subject }

        context 'when user has a project matching stash usage' do
          let!(:usage) do
            create :stash_usage, project: project, stash_yarn: stash_yarn, yards_used: 200
          end
          let(:stash_usage_id) { usage.id }

          it 'removes the stash usage' do
            expect{ usage.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it_behaves_like 'successful response'
        end

        context 'when user does not have a project matching stash usage' do
          let!(:usage) do
            create :stash_usage, project: someone_elses_project, stash_yarn: stash_yarn, yards_used: 200
          end
          let(:stash_usage_id) { usage.id }

          it 'does not remove the stash usage' do
            expect(usage.reload).to_not be_changed
          end

          it_behaves_like 'redirects to root path'
        end
      end

      context 'when stash usage does not exist' do
        let(:stash_usage_id) { -1 }

        before { subject }

        it_behaves_like 'successful response'
      end
    end
  end
end
