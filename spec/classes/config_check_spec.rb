require 'spec_helper'

describe 'oath' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        context "Put stuff here" do
          let(:params) do
            { 
              'oath_users' => :undef,
              'oath' => true
              'pam' => true
            }
          it { is_expected.to compile }
          it { is_expected.to_not contain_file('/etc/liboath/users.oath')
        end

        good_pin  = ['','-','+','1234','1234567890'] 
        good_user = ['root','s1_mp']
        good_type = ['HOTP','HOTP/T30','HOTP/T60','HOTP/T30/6','HOTP/T3022222/121212','HOTP/6']
        good_key  = ['1234','aasdf1234k']
        bad_pin   = []
        bad_user  = []
        bad_type  = []
        bad_key   = []
        context "Should compile parameters one user" do
          let(:hieradata) {'second'}
          it { is_expected.to compile }
          it { is_expected.to contain_file('/etc/liboath/users.oath').with_content(<<-EOM.gsub(/^\s+/,'')
              #{user_type}\t#{user}\t#{pin}\t#{user_key}
              EOM
            )
          }
        end
        context "Should compile parameters one user defaults and overriding" do
          let(:hieradata) {'second'}
          it { is_expected.to compile }
          it { is_expected.to contain_file('/etc/liboath/users.oath').with_content(<<-EOM.gsub(/^\s+/,'')
              #{user_type}\t#{user}\t#{pin}\t#{user_key}
              EOM
            )
          }
        end
        context "Should compile parameters two users defaults and overriding" do
          let(:hieradata) {'second'}
          it { is_expected.to compile }
          it { is_expected.to contain_file('/etc/liboath/users.oath').with_content(<<-EOM.gsub(/^\s+/,'')
              #{defualt_type}\troot\t#{default_pin}\t#{root_key}
              #{user_type}\t#{user}\t#{pin}\t#{user_key}
              EOM
            )
          }
        end
        context "Should not compile parameters" do
          let(:params) { 'oath' => true }
          let(:hieradata) {'second'}
          it { is_expected.to_not compile }
        end
      end
    end
  end
end
