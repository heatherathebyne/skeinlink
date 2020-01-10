require 'rails_helper'

RSpec.describe Project do
  describe '.public_for_user' do
    let(:user1) { build_stubbed(:user) }
    let(:user2) { build_stubbed(:user) }
    let!(:user1_private) { create :project, :private, user: user1 }
    let!(:user1_public) { create :project, :public, user: user1 }
    let!(:user2_private) { create :project, :private, user: user2 }

    context 'when user id is nil' do
      it 'returns an empty association' do
        expect(Project.public_for_user(nil)).to eq([])
      end
    end

    context 'when user id is not nil' do
      context 'when user has public projects' do
        it 'returns only public projects for the given user' do
          expect(Project.public_for_user(user1.id)).to eq([user1_public])
        end
      end

      context 'when user does not have public projects' do
        it 'returns an empty association' do
          expect(Project.public_for_user(user2.id)).to eq([])
        end
      end
    end
  end
end
