require 'rails_helper'

RSpec.describe YarnCompany do
  describe 'callbacks' do
    describe '#fix_referral_link' do
      subject { create(:yarn_company, referral_link: link).referral_link }

      context 'when product has a referral link' do
        let(:link) { 'yarn.coffee' }

        it { is_expected.to eq 'http://yarn.coffee' }
      end

      context 'when product does not have a referral link' do
        let(:link) { nil }

        it { is_expected.to be_blank }
      end
    end
  end
end
