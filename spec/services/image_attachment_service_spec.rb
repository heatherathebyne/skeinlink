require 'rails_helper'
include ActionDispatch::TestProcess::FixtureFile

RSpec.describe ImageAttachmentService do
  let(:png_image) { fixture_file_upload('files/images/png-test-1.png', 'image/png') }
  let(:jpg_image) { fixture_file_upload('files/images/jpg-test-1.jpg', 'image/jpeg') }
  let(:non_image_1) { fixture_file_upload('files/not_an_image1.txt', 'text/plain') }
  let(:non_image_2) { fixture_file_upload('files/not_an_image2.txt', 'text/plain') }

  let(:multi_image_record) { double('AR record') }
  let(:single_image_record) { double('AR record with single image') }
  let(:record) { multi_image_record } # by default, we test single_image_record later
  let(:record_images) { double('ActiveStorage images') }

  before do
    allow(record_images).to receive(:attach)
    allow(multi_image_record).to receive(:images).and_return(record_images)
    allow(single_image_record).to receive(:image).and_return(record_images)
  end

  subject { ImageAttachmentService.new(record: record, images: images).call }

  context 'when one image is provided' do
    let(:images) { png_image }
    before { subject }

    it 'attaches the image to the record' do
      expect(record_images).to have_received(:attach).with(png_image)
    end
  end

  context 'when no images are provided' do
    let(:images) { [] }

    it 'does not blow up' do
      expect{ subject }.to_not raise_error
    end
  end

  context 'when many valid images are provided' do
    let(:images) { [png_image, jpg_image] }
    before { subject }

    it 'attaches all images to the record' do
      expect(record_images).to have_received(:attach).with(png_image).ordered
      expect(record_images).to have_received(:attach).with(jpg_image).ordered
    end
  end

  context 'when some non-image attachments are provided' do
    let(:images) { [png_image, non_image_1, jpg_image] }

    it 'attaches the real images to the record' do
      subject
      expect(record_images).to have_received(:attach).with(png_image).ordered
      expect(record_images).to have_received(:attach).with(jpg_image).ordered
      expect(record_images).to_not have_received(:attach).with(non_image_1)
    end

    it 'returns an array with the rejected attachments' do
      expect(subject).to eq([non_image_1])
    end
  end

  context 'when image processing fails for some images' do
    let(:images) { [png_image, jpg_image] }
    before do
      allow(png_image).to receive_message_chain(:tempfile, :path).and_return('png_image_path')
      allow(MiniMagick::Image).to receive(:new).with('png_image_path').and_raise(RuntimeError)
      allow(MiniMagick::Image).to receive(:new).and_call_original
    end

    it 'attaches the successful images to the record' do
      subject
      expect(record_images).to_not have_received(:attach).with(png_image)
      expect(record_images).to have_received(:attach).with(jpg_image)
    end

    it 'returns an array with the failed images' do
      expect(subject).to eq([png_image])
    end
  end

  context 'when attempting to attach one image to a record which has_one_attached :image' do
    let(:record) { single_image_record }
    let(:images) { png_image }

    it 'attaches the images to the record' do
      subject
      expect(record_images).to have_received(:attach).with(png_image)
    end
  end

  context 'when no images are provided to has_one_attached :image' do
    let(:record) { single_image_record }
    let(:images) { [] }

    it 'does not blow up' do
      expect{ subject }.to_not raise_error
    end
  end

  context 'when attempting to attach many images to a record which has_one_attached :image' do
    let(:record) { single_image_record }
    let(:images) { [png_image, non_image_1, jpg_image] }

    it 'attaches the last successful image to the record' do
      subject
      expect(record_images).to have_received(:attach).with(png_image).ordered
      expect(record_images).to have_received(:attach).with(jpg_image).ordered
      expect(record_images).to_not have_received(:attach).with(non_image_1)
    end
  end
end
