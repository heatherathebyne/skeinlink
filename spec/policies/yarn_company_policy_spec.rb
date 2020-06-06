require 'rails_helper'

RSpec.describe YarnCompanyPolicy do
  subject { described_class }

  permissions :update? do
    let(:record) { build :yarn_company, created_by: 47, created_at: try(:created_at) || Time.current }

    context 'when user is a maintainer' do
      let(:user) { build :user, :maintainer }

      it { is_expected.to permit user, record }
    end

    context 'when user is not a maintainer' do
      let(:user) { build :user, id: 47 }

      context 'when user created the record' do
        context 'when record is less than eight days old' do
          let(:created_at) { Time.current - 1.day }

          it { is_expected.to permit user, record }
        end

        context 'when record is more than eight days old' do
          let(:created_at) { Time.current - 9.days }

          it { is_expected.to_not permit user, record }
        end
      end

      context 'when user did not create the record' do
        let(:user) { build :user, id: 23 }

        it { is_expected.to_not permit user, record }
      end
    end
  end

  permissions :edit_referral_links? do
    let(:record) { build :yarn_company }

    context 'when user is a maintainer' do
      let(:user) { build :user, :maintainer }

      it { is_expected.to permit user, record }
    end

    context 'when user is not a maintainer' do
      let(:user) { build :user }

      it { is_expected.to_not permit user, record }
    end
  end
end
