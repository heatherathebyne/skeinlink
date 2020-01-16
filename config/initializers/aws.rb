require 'aws-sdk-s3'

Aws.config.update({
  region: Rails.configuration.skeinlink[:s3_region],
  endpoint: Rails.configuration.skeinlink[:s3_endpoint]
})
