require 'spec_helper'

describe 'network' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        context 'with default parameters' do
          it { is_expected.to create_class('network') }
          it { is_expected.to contain_service('network').with_ensure('running') }
          it { is_expected.to create_file('/usr/local/sbin/careful_network_restart.sh').with_content(/"puppet \\\(agent\\\|apply\\\)"/) }
        end

        context 'with auto_restart => false' do
          let(:params) {{ :auto_restart => false }}
          it { is_expected.to create_file('/usr/local/sbin/careful_network_restart.sh').with_content(/\/bin\/true/) }
        end

      end
    end
  end
end
