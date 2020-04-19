# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::redis' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      case os_facts[:operatingsystem]
      when 'RedHat', 'CentOS', 'Debian', 'Ubuntu'
        it { is_expected.to compile }
        it { is_expected.to contain_class('icinga::redis::globals') }
        it { is_expected.to contain_class('redis') }
      else
        it { is_expected.to compile.and_raise_error(/not supported/) }
      end

    end
  end
end
