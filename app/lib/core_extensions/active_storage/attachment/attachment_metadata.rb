module CoreExtensions
  module ActiveStorage
    module Attachment
      module AttachmentMetadata
        def image_attribution
          attribution_string = if attribution.blank?
                                 "#{created_at.year} #{record&.default_image_owner}"
                               else
                                 attribution
                               end
          "image ©#{attribution_string}"
        end
      end
    end
  end
end
