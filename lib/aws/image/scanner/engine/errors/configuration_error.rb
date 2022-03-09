require_relative 'error.rb'

module Aws
  module Image
    module Scanner
      module Engine
        module Errors
          class ConfigurationError < Aws::Image::Scanner::Engine::Errors::Error
            def initialize(msg)
              super(msg)
            end
          end
        end
      end
    end
  end
end
