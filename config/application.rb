require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skeinlink
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Include site-specific configuration
    begin
      config.skeinlink = config_for(:skeinlink)
    rescue
      config.skeinlink = config_for(:skeinlink_defaults)
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += ["#{config.root}/app/services"]

    config.to_prepare do
      ActiveStorage::Attachment.include CoreExtensions::ActiveStorage::Attachment::AttachmentMetadata

      Warden::Strategies.add(:sso_with_discourse, SsoWithDiscourseStrategy)
    end

    # https://github.com/collectiveidea/audited/issues/631
    # https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
    config.active_record.yaml_column_permitted_classes =
      %w[String Integer NilClass Float Time Date FalseClass Hash Array DateTime TrueClass BigDecimal
      ActiveSupport::TimeWithZone ActiveSupport::TimeZone ActiveSupport::HashWithIndifferentAccess
      ActsAsTaggableOn::TagList Symbol ActsAsTaggableOn::DefaultParser]

    config.active_storage.variant_processor = :mini_magick
  end
end
