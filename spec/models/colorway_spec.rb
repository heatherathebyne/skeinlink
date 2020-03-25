require 'rails_helper'

RSpec.describe Colorway do
  describe 'validations' do
    subject { Colorway.new(yarn_product: yarn_product, name: name, number: number) }

    describe 'presence' do
      let(:yarn_product) { build(:yarn_product) }

      context 'when only name is present' do
        let(:name) { 'Natural' }
        let(:number) { nil }

        it { is_expected.to be_valid }
      end

      context 'when only name is present, but blank' do
        let(:name) { '' }
        let(:number) { nil }

        it { is_expected.to_not be_valid }
      end

      context 'when only number is present' do
        let(:name) { nil }
        let(:number) { '001' }

        it { is_expected.to be_valid }
      end

      context 'when only number is present, but blank' do
        let(:name) { nil }
        let(:number) { '' }

        it { is_expected.to_not be_valid }
      end

      context 'when both name and number are present' do
        let(:name) { 'Natural' }
        let(:number) { '001' }

        it { is_expected.to be_valid }
      end

      context 'when neither name nor number are present' do
        let(:name) { nil }
        let(:number) { nil }

        it { is_expected.to_not be_valid }
      end
    end

    describe 'uniqueness' do
      let(:yarn_product) { create(:yarn_product) }
      let(:other_yarn_product) { create(:yarn_product) }

      context 'when more than one yarn product has the name' do
        let(:name) { 'Natural' }
        let(:number) { nil }

        before { create(:colorway, yarn_product: other_yarn_product, name: name, number: number) }

        it { is_expected.to be_valid }
      end

      context 'when the name is duplicated within the yarn product' do
        let(:name) { 'Natural' }
        let(:number) { nil }

        before { create(:colorway, yarn_product: yarn_product, name: name, number: number) }

        it { is_expected.to_not be_valid }
      end

      context 'when there is more than one blank name within the yarn product' do
        let(:name) { nil }
        let(:number) { '001' }

        before { create(:colorway, yarn_product: yarn_product, name: name, number: '002') }

        it { is_expected.to be_valid }
      end

      context 'when more than one yarn product has the number' do
        let(:name) { nil }
        let(:number) { '001' }

        before { create(:colorway, yarn_product: other_yarn_product, name: name, number: number) }

        it { is_expected.to be_valid }
      end

      context 'when the number is duplicated within the yarn product' do
        let(:name) { nil }
        let(:number) { '001' }

        before { create(:colorway, yarn_product: yarn_product, name: name, number: number) }

        it { is_expected.to_not be_valid }
      end

      context 'when there is more than one blank number within the yarn product' do
        let(:name) { 'Natural' }
        let(:number) { nil }

        before { create(:colorway, yarn_product: yarn_product, name: 'Hyacinth', number: number) }

        it { is_expected.to be_valid }
      end
    end
  end
end
