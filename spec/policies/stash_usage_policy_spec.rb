require 'rails_helper'

RSpec.describe StashUsagePolicy do
  subject { described_class }

  shared_examples 'ensures ids are valid for current user' do
    let(:user) { create :user }
    let(:some_other_user) { create :user }
    let(:record) { StashUsage.new(project_id: project.id, stash_yarn_id: stash_yarn.id) }

    context 'when project and stash yarn exist for current user' do
      let(:project) { create :project, user_id: user.id }
      let(:stash_yarn) { create :stash_yarn, :with_name, user_id: user.id }

      it { is_expected.to permit user, record }
    end

    context 'when project does not exist for current user' do
      let(:project) { create :project, user_id: some_other_user.id }
      let(:stash_yarn) { create :stash_yarn, :with_name, user_id: user.id }

      it { is_expected.to_not permit user, record }
    end

    context 'when stash yarn does not exist for current user' do
      let(:project) { create :project, user_id: user.id }
      let(:stash_yarn) { create :stash_yarn, :with_name, user_id: some_other_user.id }

      it { is_expected.to_not permit user, record }
    end

    context 'when neither project nor stash yarn exist for current user' do
      let(:project) { create :project, user_id: some_other_user.id }
      let(:stash_yarn) { create :stash_yarn, :with_name, user_id: some_other_user.id }

      it { is_expected.to_not permit user, record }
    end
  end

  permissions :create? do
    it_behaves_like 'ensures ids are valid for current user'
  end

  permissions :destroy? do
    it_behaves_like 'ensures ids are valid for current user'
  end
end
