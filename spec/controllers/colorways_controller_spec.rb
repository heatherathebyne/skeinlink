require 'rails_helper'

RSpec.describe ColorwaysController do
  describe '#create' do
    context 'when user is not authenticated' do
      before { post :create, params: { yarn_product_id: 1 } }
      it_behaves_like 'redirects to login'
    end

    context 'when user is authenticated' do
      before do
        sign_in user
        allow(ImageAttachmentService).to receive(:call)
        post :create, params: params
      end

      context 'when user is not authorized to create a colorway' do
        let(:user) { create :user }
        let(:params) { { yarn_product_id: 1 } }

        it_behaves_like 'displays maintainer flash'
        it_behaves_like 'redirects to root path'
      end

      context 'when user is authorized to create a colorway' do
        let(:sample_image_data) { fixture_file_upload file_fixture('images/jpg-test-1.jpg') }
        let(:user) { create :user, :maintainer }
        let(:yarn_product) { create :yarn_product }
        let(:colorway) { Colorway.find_by(name: 'Clown Barf', yarn_product_id: yarn_product.id) }
        let(:params) do
          { yarn_product_id: yarn_product.id, colorway: { name: 'Clown Barf', image: sample_image_data } }
        end

        it 'redirects to the parent yarn product' do
          expect(response).to redirect_to yarn_product_path(yarn_product)
        end

        it 'creates the new colorway with the expected attributes' do
          expect(colorway.name).to eq 'Clown Barf'
          expect(colorway.created_by).to eq user.id
        end

        it 'attaches the uploaded image' do
          expect(ImageAttachmentService).to have_received(:call).with(hash_including(
            images: kind_of(ActionDispatch::Http::UploadedFile), record: kind_of(Colorway)
          ))
        end
      end
    end
  end
end
