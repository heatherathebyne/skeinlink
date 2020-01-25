require 'rails_helper'

RSpec.describe User do
  describe '#superadmin?' do
    subject { user.superadmin? }

    context 'when user is superadmin' do
      let(:user) { build(:user, :superadmin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is admin' do
      let(:user) { build(:user, :admin) }
      it { is_expected.to eq(false) }
    end

    context 'when user is maintainer' do
      let(:user) { build(:user, :maintainer) }
      it { is_expected.to eq(false) }
    end

    context 'when user is moderator' do
      let(:user) { build(:user, :moderator) }
      it { is_expected.to eq(false) }
    end
  end

  describe '#admin?' do
    subject { user.admin? }

    context 'when user is superadmin' do
      let(:user) { build(:user, :superadmin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is admin' do
      let(:user) { build(:user, :admin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is maintainer' do
      let(:user) { build(:user, :maintainer) }
      it { is_expected.to eq(false) }
    end

    context 'when user is moderator' do
      let(:user) { build(:user, :moderator) }
      it { is_expected.to eq(false) }
    end
  end

  describe '#maintainer?' do
    subject { user.maintainer? }

    context 'when user is superadmin' do
      let(:user) { build(:user, :superadmin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is admin' do
      let(:user) { build(:user, :admin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is maintainer' do
      let(:user) { build(:user, :maintainer) }
      it { is_expected.to eq(true) }
    end

    context 'when user is moderator' do
      let(:user) { build(:user, :moderator) }
      it { is_expected.to eq(false) }
    end
  end

  describe '#moderator?' do
    subject { user.moderator? }

    context 'when user is superadmin' do
      let(:user) { build(:user, :superadmin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is admin' do
      let(:user) { build(:user, :admin) }
      it { is_expected.to eq(true) }
    end

    context 'when user is maintainer' do
      let(:user) { build(:user, :maintainer) }
      it { is_expected.to eq(false) }
    end

    context 'when user is moderator' do
      let(:user) { build(:user, :moderator) }
      it { is_expected.to eq(true) }
    end
  end
end
