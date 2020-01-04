THUMBNAIL_VARIANT_OPTIONS = { resize_to_limit: [250, 250], auto_orient: true, strip: true }.freeze
FULL_SIZE_VARIANT_OPTIONS = { resize_to_limit: [1280, 1280], auto_orient: true, strip: true }.freeze

module ImageTools
  extend ActiveSupport::Concern

  included do
    def thumb_and_full_images
      images.map do |image|
        { thumb: image.variant(**THUMBNAIL_VARIANT_OPTIONS), full: image.variant(**FULL_SIZE_VARIANT_OPTIONS) }
      end
    end

    def full_images
      images.map do |image|
        image.variant(**FULL_SIZE_VARIANT_OPTIONS)
      end
    end

    def thumb_images
      images.map do |image|
        image.variant(**THUMBNAIL_VARIANT_OPTIONS)
      end
    end

    def thumb_images_with_attachment_id
      images.map do |image|
        { thumb: image.variant(**THUMBNAIL_VARIANT_OPTIONS), attachment_id: image.id }
      end
    end

    def full_image
      image.variant(**FULL_SIZE_VARIANT_OPTIONS)
    end

    def thumb_image
      image.variant(**THUMBNAIL_VARIANT_OPTIONS)
    end

    private

    def replace_image_filenames
      images.each do |image|
        image.blob.filename = SecureRandom.hex(8) # This is only persisted on new images
      end
    end

    def replace_image_filename
      image.blob.filename = SecureRandom.hex(8) # This is only persisted on new images
    end
  end
end
