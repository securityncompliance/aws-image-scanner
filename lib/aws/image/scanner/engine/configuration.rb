# frozen_string_literal: true
require_relative 'errors/configuration_error.rb'

module Aws
  module Image
    module Scanner
      module Engine
        class Configuration
          SEVERITY_STATUSES = {
            informational: 'INFORMATIONAL',
            low: 'LOW',
            medium: 'MEDIUM',
            high: 'HIGH',
            critical: 'CRITICAL',
            undefined: 'UNDEFINED'
          }.freeze

          attr_writer :region_name, :aws_access_key_id, :aws_secret_access_key

          def initialize(region_name: nil, aws_access_key_id: nil, aws_secret_access_key: nil, tolerate_statuses: [SEVERITY_STATUSES[:informational], SEVERITY_STATUSES[:low]], max_severity_count: nil)
            @region_name = region_name
            @aws_secret_access_key = aws_secret_access_key
            @aws_access_key_id = aws_access_key_id
            @tolerate_statuses = tolerate_statuses
            @max_severity_count = max_severity_count
            parse_and_validate_configuration
          end

          def region_name
            return_value = @region_name || ENV.fetch('AWS_REGION_NAME', nil)
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_REGION_NAME' unless return_value
            return_value
          end

          def aws_access_key_id
            return_value = @aws_access_key_id || ENV.fetch('AWS_ACCESS_KEY_ID', nil)
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_ACCESS_KEY_ID' unless return_value
            return_value
          end

          def aws_secret_access_key
            return_value = @aws_secret_access_key || ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_SECRET_ACCESS_KEY' unless return_value
            return_value
          end

          def tolerate_statuses
            @tolerate_statuses
          end

          def max_severity_count
            @max_severity_count || ENV.fetch('MAX_SEVERITY_COUNT')
          end
          
          private

          def parse_and_validate_configuration
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses cannot be nil' if @tolerate_statuses.nil?
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses has to be an Array[]' if !@tolerate_statuses.is_a?(Array)
            raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses cannot be empty Array[]' if @tolerate_statuses.empty?
            valid_severity_statuses = SEVERITY_STATUSES.values
            if (valid_severity_statuses.intersection @tolerate_statuses) !=  @tolerate_statuses
              raise "Must provide one or more of tolerate_statuses: #{valid_severity_statuses}"
            end

            if !@max_severity_count.nil?
              @max_severity_count = number_or_nil(@max_severity_count)
              raise Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'max_severity_count has to be Integer' if !@max_severity_count.is_a?(Integer)
            end
          end

          def number_or_nil(string)
            Integer(string)
          rescue ArgumentError
            nil
          end
        end
      end
    end
  end
end