# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::web' do
  on_supported_os.each do |os, facts|
    next unless %w[RedHat Debian].include?(facts[:os]['family'])

    context "on #{os}" do
      let(:facts) do
        facts.merge(os: facts[:os].merge(selinux: { enabled: true }))
      end

      let(:params) do
        {
          db_pass: 'supersecret',
          api_pass: 'supersecret',
          apache_cgi_pass_auth: true,
          manage_selinux: true,
        }
      end

      it { is_expected.to contain_class('icingaweb2').with({ 'manage_selinux' => true }) }

      it {
        is_expected.to contain_selinux__port('icinga-web-php-fpm-tcp-9000').with(
          ensure: 'present',
          seltype: 'http_port_t',
          protocol: 'tcp',
          port: 9000,
        )
      }
    end
  end
end
