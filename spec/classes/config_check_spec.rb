require 'spec_helper'

describe 'oath' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        context "Put stuff here" do
          puts("stuff")
        end
      end
    end
  end
end
