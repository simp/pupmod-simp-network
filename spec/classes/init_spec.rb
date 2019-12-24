require 'spec_helper'

describe 'network' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts){ os_facts }

        context 'with default parameters' do
          it { is_expected.to create_class('network') }
          it { is_expected.to create_class('network::service') }

          if os_facts[:simplib__networkmanager] && os_facts[:simplib__networkmanager][:enabled]
            it { is_expected.to create_class('network::service::network_manager') }
            it { is_expected.to_not contain_service('network').with_ensure('running') }
            it { is_expected.to_not create_file('/usr/local/sbin/careful_network_restart.sh').with_content(/"puppet \\\\\(agent\\\\\|apply\\\\\)"/) }
            it { is_expected.to contain_service('NetworkManager').with_ensure('running') }
            it { is_expected.to create_file('/usr/local/sbin/careful_network_manager_restart.sh').with_content(/"puppet \\\\\(agent\\\\\|apply\\\\\)"/) }
          else
            it { is_expected.to create_class('network::service::legacy') }
            it { is_expected.to contain_service('network').with_ensure('running') }
            it { is_expected.to create_file('/usr/local/sbin/careful_network_restart.sh').with_content(/"puppet \\\\\(agent\\\\\|apply\\\\\)"/) }
            it { is_expected.to_not contain_service('NetworkManager').with_ensure('running') }
            it { is_expected.to_not create_file('/usr/local/sbin/careful_network_manager_restart.sh').with_content(/"puppet \\\\\(agent\\\\\|apply\\\\\)"/) }
          end
        end
      end
    end
  end
end
