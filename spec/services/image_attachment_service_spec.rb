require 'rails_helper'
include ActionDispatch::TestProcess::FixtureFile

RSpec.describe ImageAttachmentService do
  # These image tempfiles get mutated in place; don't mutate the originals
  let(:tempfile_dir) { File.join(Rails.root, 'tmp', 'image_attachment_service_spec') }

  before do
    FileUtils.mkdir_p(tempfile_dir)
    FileUtils.cp([file_fixture('images/jpg-test-1.jpg'),
                  file_fixture('images/png-test-1.png'),
                  file_fixture('not_an_image1.txt')],
                 tempfile_dir
                )
  end

  after do
    FileUtils.rm_r(tempfile_dir)
  end

  let(:png_image) do
    ActionDispatch::Http::UploadedFile.new({
      filename: 'png-test-1.png',
      type: 'image/png',
      tempfile: File.open(File.join(tempfile_dir, 'png-test-1.png'))
    })
  end

  let(:jpg_image) do
    ActionDispatch::Http::UploadedFile.new({
      filename: 'jpg-test-1.jpg',
      type: 'image/jpeg',
      tempfile: File.open(File.join(tempfile_dir, 'jpg-test-1.jpg'))
    })
  end

  let(:non_image_1) do
    ActionDispatch::Http::UploadedFile.new({
      filename: 'not_an_image1.txt',
      type: 'text/plain',
      tempfile: File.open(File.join(tempfile_dir, 'not_an_image1.txt'))
    })
  end

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

    it 'attaches all images to the record' do
      subject
      expect(record_images).to have_received(:attach).with(png_image).ordered
      expect(record_images).to have_received(:attach).with(jpg_image).ordered
    end

    it 'renames the files' do
      expect(png_image).to receive(:original_filename=)
      expect(jpg_image).to receive(:original_filename=)
      subject
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

  context 'when record has_one_attached :image' do
    context 'when attempting to attach one image' do
      let(:record) { single_image_record }
      let(:images) { png_image }

      it 'attaches the image to the record' do
        subject
        expect(record_images).to have_received(:attach).with(png_image)
      end

      it 'renames the file' do
        expect(png_image).to receive(:original_filename=)
        subject
      end
    end

    context 'when no images are provided to has_one_attached :image' do
      let(:record) { single_image_record }
      let(:images) { [] }

      it 'does not blow up' do
        expect{ subject }.to_not raise_error
      end
    end

    context 'when attempting to attach many images' do
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
end
