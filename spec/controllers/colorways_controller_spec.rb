require 'rails_helper'

RSpec.describe ColorwaysController do
  describe '#index' do
    it 'renders' do
      get :index
      expect(response).to be_success
    end
  end
end
