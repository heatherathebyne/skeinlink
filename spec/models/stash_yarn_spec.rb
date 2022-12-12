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

  describe 'scopes' do
    describe '#sort_by_yarn_name_asc' do
      let!(:stash_1) { create :stash_yarn, name: 'ddddd' }
      let!(:stash_2) do
        create :stash_yarn, name: 'irrelevant', yarn_product: create(:yarn_product, name: 'ccccc')
      end
      let!(:stash_3) { create :stash_yarn, name: 'BBBBB' }
      let!(:stash_4) do
        create :stash_yarn, name: 'super irrelevant',
          yarn_product: create(:yarn_product, name: 'aaaaa')
      end

      subject { StashYarn.sort_by_yarn_name_asc }

      it 'returns records in the expected order' do
        expect(subject.first).to eq stash_4
        expect(subject.second).to eq stash_3
        expect(subject.third).to eq stash_2
        expect(subject.fourth).to eq stash_1
      end

      it 'can be chained with other relational things' do
        expect(subject.limit(2).length).to eq 2
      end
    end

    describe '#sort_by_yarn_maker_name_asc' do
      let!(:a_yarn_company) { create(:yarn_company, name: 'AaaYarnCompany') }
      let!(:z_yarn_company) { create(:yarn_company, name: 'ZzzYarnCompany') }

      let!(:stash_1) { create :stash_yarn, name: 'ddddd' }
      let!(:stash_2) do
        create :stash_yarn, name: 'irrelevant',
          yarn_product: create(:yarn_product, name: 'ccccc', yarn_company: z_yarn_company)
      end
      let!(:stash_3) { create :stash_yarn, name: 'BBBBB' }
      let!(:stash_4) do
        create :stash_yarn, name: 'super irrelevant',
          yarn_product: create(:yarn_product, name: 'aaaaa', yarn_company: z_yarn_company)
      end
      let!(:stash_5) do
        create :stash_yarn,
          yarn_product: create(:yarn_product, name: 'eeeee', yarn_company: a_yarn_company)
      end

      subject { StashYarn.sort_by_yarn_maker_name_asc }

      it 'returns records in the expected order' do
        expect(subject.first).to eq stash_5
        expect(subject.second).to eq stash_3
        expect(subject.third).to eq stash_1
        expect(subject.fourth).to eq stash_4
        expect(subject.fifth).to eq stash_2
      end

      it 'can be chained with other relational things' do
        expect(subject.limit(2).length).to eq 2
      end
    end
  end
end
