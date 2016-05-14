require 'spec_helper'

describe 'network' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
      let(:facts) { os_facts }
        it { is_expected.to create_class('network') }
        it { is_expected.to contain_service('network').with_ensure('running') }
        it { is_expected.to create_file('/usr/local/sbin/careful_network_restart.sh') }
      end
    end
  end
end
