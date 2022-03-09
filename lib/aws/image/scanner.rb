# frozen_string_literal: true

require_relative "scanner/version"

module Aws
  module Image
    module Scanner
      class Error < StandardError; end
      def run
        "testing runner"
      end
    end
  end
end
