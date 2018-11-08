require 'spec_helper'

describe 'oath' do
  shared_examples_for "a structured module" do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('oath') }
    it { is_expected.to contain_class('oath') }
    it { is_expected.to contain_class('oath::install').that_comes_before('Class[oath::config]') }
    it { is_expected.to contain_class('oath::config') }
    it { is_expected.to contain_class('oath::service').that_subscribes_to('Class[oath::config]') }

    it { is_expected.to contain_service('oath') }
    it { is_expected.to contain_package('oath').with_ensure('present') }
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "oath class without any parameters" do
          let(:params) {{ }}
          it_behaves_like "a structured module"
          it { is_expected.to contain_class('oath').with_trusted_nets(['127.0.0.1/32']) }
        end

        context "oath class with firewall enabled" do
          let(:params) {{
            :enable_firewall => true
          }}

          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('oath::config::firewall') }

          it { is_expected.to contain_class('oath::config::firewall').that_comes_before('Class[oath::service]') }
          it { is_expected.to create_iptables__listen__tcp_stateful('allow_oath_tcp_connections').with_dports(9999)
          }
        end

        context "oath class with selinux enabled" do
          let(:params) {{
            :enable_selinux => true
          }}

          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('oath::config::selinux') }
          it { is_expected.to contain_class('oath::config::selinux').that_comes_before('Class[oath::service]') }
          it { is_expected.to create_notify('FIXME: selinux') }
        end

        context "oath class with auditing enabled" do
          let(:params) {{
            :enable_auditing => true
          }}

          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('oath::config::auditing') }
          it { is_expected.to contain_class('oath::config::auditing').that_comes_before('Class[oath::service]') }
          it { is_expected.to create_notify('FIXME: auditing') }
        end

        context "oath class with logging enabled" do
          let(:params) {{
            :enable_logging => true
          }}

          ###it_behaves_like "a structured module"
          it { is_expected.to contain_class('oath::config::logging') }
          it { is_expected.to contain_class('oath::config::logging').that_comes_before('Class[oath::service]') }
          it { is_expected.to create_notify('FIXME: logging') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'oath class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta'
      }}

      it { expect { is_expected.to contain_package('oath') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
