# frozen_string_literal: true

require_relative 'scanner/engine/configuration.rb'
require 'aws-sdk'

module Aws
  module Image
    module Scanner
      def self.run(repository_name, image_digest, image_tag, options = {})
        configuration = Aws::Image::Scanner::Engine::Configuration.new(**options)
        # binding.pry
        client = Aws::ECR::Client.new(
          region: configuration.region_name,
          credentials: {
            access_key_id: configuration.aws_access_key_id,
            secret_access_key: configuration.aws_secret_access_key
          }
        )
        client.describe_image_scan_findings({
          repository_name: repository_name,
          image_id: {
            image_digest: image_digest,
            image_tag: image_tag
          }
        })
      end
    end
  end
end
