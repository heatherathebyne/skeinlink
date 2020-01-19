THUMBNAIL_VARIANT_OPTIONS = { resize_to_limit: [250, 250], auto_orient: true, strip: true }.freeze

module ImageTools
  extend ActiveSupport::Concern

  included do
    def thumb_and_full_images
      images.map do |image|
        { thumb: image.variant(**THUMBNAIL_VARIANT_OPTIONS), full: image }
      end
    end

    def full_images
      images
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
      image
    end

    def thumb_image
      image.variant(**THUMBNAIL_VARIANT_OPTIONS)
    end
  end
end
