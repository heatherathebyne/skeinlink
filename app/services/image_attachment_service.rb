require 'mini_magick'

class ImageAttachmentService
  def initialize(record:, images:)
    @record = record
    @images = images.class == Array ? images : [images]
    @rejected_images = []
  end

  def self.call(record:, images:)
    self.new(record: record, images: images).call
  end

  def call
    images.each do |image|
      begin
        validate_image(image)
        rename_image(image)
        process_image(image)
        attach_image(image)
      rescue StandardError => e
        rejected_images << image
      end
    end

    rejected_images
  end

  private

  attr_reader :record, :images
  attr_accessor :rejected_images

  def validate_image(image)
    raise 'Not a jpg or png image' unless ['image/png', 'image/jpg', 'image/jpeg'].include?(image.content_type)
  end

  def rename_image(image)
    image.original_filename = SecureRandom.hex(8)
  end

  def process_image(image)
    MiniMagick::Image.new(image.tempfile.path) do |opt|
      opt.auto_orient
      opt.strip
      opt.resize '1280x1280>'
    end
  end

  def attach_image(image)
    if record.respond_to?(:image)
      record.image.attach(image)
      return
    end

    record.images.attach(image)
  end
end
