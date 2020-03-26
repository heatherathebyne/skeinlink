require 'rails_helper'

RSpec.describe StashYarn do
  describe '#name' do
    subject { stash_yarn.name }

    context 'when there is an associated yarn product' do
      let(:stash_yarn) { build :stash_yarn, :with_yarn_product }

      it { is_expected.to eq(stash_yarn.yarn_product.name) }
    end

    context 'when there is no associated yarn product' do
      let(:stash_yarn) { build :stash_yarn, name: 'Cascade 220' }

      it { is_expected.to eq(stash_yarn.name) }
    end
  end

  describe '#colorway_name' do
    subject { stash_yarn.colorway_name }

    context 'when there is an associated colorway' do
      let(:stash_yarn) { build :stash_yarn, :with_colorway }

      it { is_expected.to eq(stash_yarn.colorway.name) }
    end

    context 'when there is no associated colorway' do
      let(:stash_yarn) { build :stash_yarn, colorway_name: 'Cascade 220' }

      it { is_expected.to eq('Cascade 220') }
    end
  end

  describe '#default_image_owner' do
    subject { stash_yarn.default_image_owner }
    let(:stash_yarn) { build :stash_yarn }
    it { is_expected.to eq(stash_yarn.user.name) }
  end

  describe 'validations' do
    describe '#has_a_name_or_product' do
      subject { stash_yarn }

      context 'when it has no name or yarn product' do
        let(:stash_yarn) { build :stash_yarn }

        it { is_expected.to_not be_valid }
      end

      context 'when it has a name' do
        let(:stash_yarn) { build :stash_yarn, name: 'Lovely Handspun' }

        it { is_expected.to be_valid }
      end

      context 'when it has a yarn product' do
        let(:stash_yarn) { build :stash_yarn, :with_yarn_product }

        it { is_expected.to be_valid }
      end
    end
  end
end
