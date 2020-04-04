require 'rails_helper'

RSpec.describe YarnProduct do
  describe '#name_with_company' do
    subject { YarnProduct.new(name: 'Mandala', yarn_company: yarn_company).name_with_company }

    context 'when yarn company is present' do
      let(:yarn_company) { build(:yarn_company, name: 'Lion Brand') }

      it { is_expected.to eq 'Lion Brand Mandala' }
    end

    context 'when yarn company is missing' do
      let(:yarn_company) { nil }

      it { is_expected.to eq 'Mandala' }
    end
  end

  describe '#yarn_company_name' do
    subject { YarnProduct.new(yarn_company: yarn_company).yarn_company_name }

    context 'when yarn company is present' do
      let(:yarn_company) { build(:yarn_company, name: 'Lion Brand') }

      it { is_expected.to eq 'Lion Brand' }
    end

    context 'when yarn company is missing' do
      let(:yarn_company) { nil }

      it { is_expected.to be_blank }
    end
  end
end
