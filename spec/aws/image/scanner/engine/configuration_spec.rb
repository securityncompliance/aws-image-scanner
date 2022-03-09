# frozen_string_literal: true

require_relative "../../../../../lib/aws/image/scanner/engine/configuration.rb"

RSpec.describe "Aws::Image::Scanner::Engine::Configuration" do
  let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new }

  describe '.region_name' do
    context 'setting region_name via environment variable' do
      before do
        allow(ENV).to receive(:fetch).with('AWS_REGION_NAME', nil).and_return('us-east-1')
      end

      it 'returns correct region_name' do
        expect(configuration.region_name).to eq('us-east-1')
      end

      context 'explicit region_name configuration setting overrides environment' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(region_name: 'us-east-2') }

        it 'returns correct region_name (overrides environment)' do
          expect(configuration.region_name).to eq('us-east-2')
        end
      end
    end

    context 'no region_name provided via environment or as an argument' do
      let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(aws_access_key_id: 'xxx', aws_secret_access_key: 'yyy') }
      it 'raises error' do
        expect { configuration.region_name }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_REGION_NAME')
      end
    end
  end

  describe '.aws_access_key_id' do
    context 'setting aws_access_key_id via environment variable' do
      before do
        allow(ENV).to receive(:fetch).with('AWS_ACCESS_KEY_ID', nil).and_return('xxx')
      end

      it 'returns correct aws_access_key_id' do
        expect(configuration.aws_access_key_id).to eq('xxx')
      end

      context 'explicit aws_access_key_id configuration setting overrides environment' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(aws_access_key_id: 'xxxz') }

        it 'returns correct aws_access_key_id (overrides environment)' do
          expect(configuration.aws_access_key_id).to eq('xxxz')
        end
      end
    end

    context 'no aws_access_key_id provided via environment or as an argument' do
      let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(region_name: 'xxx', aws_secret_access_key: 'yyy') }
      it 'raises error' do
        expect { configuration.aws_access_key_id }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_ACCESS_KEY_ID')
      end
    end
  end

  describe '.aws_secret_access_key' do
    context 'setting aws_secret_access_key via environment variable' do
      before do
        allow(ENV).to receive(:fetch).with('AWS_SECRET_ACCESS_KEY', nil).and_return('xxx')
      end

      it 'returns correct aws_secret_access_key' do
        expect(configuration.aws_secret_access_key).to eq('xxx')
      end

      context 'explicit aws_secret_access_key configuration setting overrides environment' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(aws_secret_access_key: 'xxxz') }

        it 'returns correct aws_access_key_id (overrides environment)' do
          expect(configuration.aws_secret_access_key).to eq('xxxz')
        end
      end
    end

    context 'no aws_secret_access_key provided via environment or as an argument' do
      let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(region_name: 'xxx', aws_access_key_id: 'xxx') }
      it 'raises error' do
        expect { configuration.aws_secret_access_key }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'Please provide AWS_SECRET_ACCESS_KEY')
      end
    end
  end

  describe '.tolerate_statuses' do
    context 'setting tolerate_statuses' do
      it 'returns default tolerate_statuses' do
        expect(configuration.tolerate_statuses).to eq(['INFORMATIONAL', 'LOW'])
      end

      context 'explicit tolerate_statuses configuration overrides default' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(tolerate_statuses: ['LOW', 'HIGH']) }

        it 'returns correct tolerate_statuses (overrides default)' do
          expect(configuration.tolerate_statuses).to eq(['LOW', 'HIGH'])
        end
      end

      context 'explicit tolerate_statuses configuration overrides default, setting to nil' do
        it 'raises error' do
          expect { Aws::Image::Scanner::Engine::Configuration.new(tolerate_statuses: nil) }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses cannot be nil')
        end
      end

      context 'explicit tolerate_statuses configuration overrides default, setting to [] empty array' do
        it 'raises error' do
          expect { Aws::Image::Scanner::Engine::Configuration.new(tolerate_statuses: []) }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses cannot be empty Array[]')
        end
      end

      context 'explicit tolerate_statuses configuration overrides default, setting to non-Array value' do
        it 'raises error' do
          expect { Aws::Image::Scanner::Engine::Configuration.new(tolerate_statuses: 1) }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'tolerate_statuses has to be an Array[]')
        end
      end

      context 'explicit tolerate_statuses configuration overrides default, passing invalid tolerate_statuses' do
        it 'raises error' do
          expect { Aws::Image::Scanner::Engine::Configuration.new(tolerate_statuses: ['EXTREME']) }.to raise_error(/Must provide one or more of tolerate_statuses/)
        end
      end
    end
  end

  describe '.max_severity_count' do
    context 'setting max_severity_count via environment variable' do
      before do
        allow(ENV).to receive(:fetch).with('MAX_SEVERITY_COUNT').and_return('2')
      end

      it 'returns correct max_severity_count' do
        expect(configuration.max_severity_count).to eq('2')
      end

      context 'explicit max_severity_count configuration setting overrides environment' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(max_severity_count: 22) }

        it 'returns correct max_severity_count (overrides environment)' do
          expect(configuration.max_severity_count).to eq(22)
        end
      end

      context 'explicit max_severity_count configuration setting overrides environment, invalid value' do
        it 'raises error' do
          expect { Aws::Image::Scanner::Engine::Configuration.new(max_severity_count: 'aa') }.to raise_error(Aws::Image::Scanner::Engine::Errors::ConfigurationError, 'max_severity_count has to be Integer')
        end
      end

      context 'explicit max_severity_count configuration setting overrides environment, with integer value passed as a string' do
        let(:configuration) { Aws::Image::Scanner::Engine::Configuration.new(max_severity_count: '22') }

        it 'returns correct max_severity_count (overrides environment)' do
          expect(configuration.max_severity_count).to eq(22)
        end
      end
    end
  end

end
