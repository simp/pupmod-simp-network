require 'spec_helper'

describe 'network::global' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
      let(:facts) { os_facts }

      # Look in hieradata/default.yaml for variables that were set for this test.
      it { is_expected.to create_class('network::global') }
      it { is_expected.to create_file('/etc/sysconfig/network').with_content(/GATEWAY=1\.2\.3\.4/) }
      end
    end
  end
end
