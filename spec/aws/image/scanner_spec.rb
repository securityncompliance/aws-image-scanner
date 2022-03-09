# frozen_string_literal: true

RSpec.describe Aws::Image::Scanner do
  describe '#run' do
    before do
      allow(ENV).to receive(:fetch).with('AWS_ACCESS_KEY_ID', nil).and_return('xxx')
      allow(ENV).to receive(:fetch).with('AWS_SECRET_ACCESS_KEY', nil).and_return('yyy')
      allow(ENV).to receive(:fetch).with('AWS_REGION_NAME', nil).and_return('us-east-1')
    end

    context 'Setting AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY via environment, no value for region_name' do
      let(:new_client) { double() }
      before do
        allow(Aws::ECR::Client).to receive(:new).and_return(new_client)
        allow(new_client).to receive(:describe_image_scan_findings)
      end
    end
    
    it 'does my thing' do
      Aws::Image::Scanner.run('repo-name', 'some-digest', 'some-tag')
      expect(client).to have_received(:describe_image_scan_findings).once
    end
  end
end
