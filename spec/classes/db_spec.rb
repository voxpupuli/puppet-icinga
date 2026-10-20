# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::db' do
  on_supported_os.each do |os, facts|
    next unless %w[RedHat Debian].include?(facts[:os]['family'])

    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) do
        <<-PUPPET
        class { 'icinga2':
          confd          => false,
          manage_packages => false,
          features       => [],
        }
        PUPPET
      end

      let(:params) do
        {
          db_pass: 'supersecret',
          db_type: 'mysql',
          manage_selinux: true,
        }
      end

      it { is_expected.to contain_class('icingadb').with({ 'manage_selinux' => true }) }
    end
  end
end
