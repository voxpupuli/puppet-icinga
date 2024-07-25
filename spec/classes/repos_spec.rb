# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::repos' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults' do
        if facts[:os]['family'] == 'Debian'
          it { is_expected.to contain_apt__source('icinga-stable-release').with('ensure' => 'present') }
          it { is_expected.not_to contain_apt__source('icinga-testing-builds') }
          it { is_expected.not_to contain_apt__source('icinga-snapshot-builds') }
        end

        if facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_yumrepo('icinga-stable-release').with('enabled' => 1) }
          it { is_expected.not_to contain_yumrepo('icinga-testing-builds') }
          it { is_expected.not_to contain_yumrepo('icinga-snapshot-builds') }
          it { is_expected.not_to contain_yumrepo('powertools') }
          it { is_expected.not_to contain_yumrepo('crb') }

          if facts[:os]['name'] == 'Fedora' || facts[:os]['name'] == 'OracleLinux'
            it { is_expected.not_to contain_yumrepo('epel').with('enabled' => 1) }
          elsif Integer(facts[:os]['release']['major']) < 8
            it { is_expected.to contain_yumrepo('epel').with('enabled' => 1) }
          end
        end

        if facts[:os]['family'] == 'Suse'
          it { is_expected.to contain_zypprepo('icinga-stable-release').with('enabled' => 1) }
          it { is_expected.not_to contain_zypprepo('icinga-testing-builds') }
          it { is_expected.not_to contain_zypprepo('icinga-snapshot-builds') }
          it { is_expected.not_to contain_zypprepo('server_monitoring') }
        end
      end

      context 'with manage_stable => false, manage_testing => true, manage_plugins => true' do
        let(:params) { { manage_stable: false, manage_testing: true, manage_plugins: true } }

        if facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_apt__source('icinga-stable-release') }
          it { is_expected.to contain_apt__source('icinga-testing-builds').with('ensure' => 'present') }
          it { is_expected.to contain_apt__source('netways-plugins-release').with('ensure' => 'present') }
        end

        if facts[:os]['family'] == 'RedHat'
          it { is_expected.not_to contain_yumrepo('icinga-stable-release') }
          it { is_expected.to contain_yumrepo('icinga-testing-builds').with('enabled' => 1) }
          it { is_expected.to contain_yumrepo('netways-plugins-release').with('enabled' => 1) }
        end

        if facts[:os]['family'] == 'Suse'
          it { is_expected.not_to contain_zypprepo('icinga-stable-release') }
          it { is_expected.to contain_zypprepo('icinga-testing-builds').with('enabled' => 1) }
        end
      end

      context 'with manage_stable => false, manage_nightly => true, manage_extras => true' do
        let(:params) { { manage_stable: false, manage_nightly: true, manage_extras: true } }

        if facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_apt__source('icinga-stable-release') }
          it { is_expected.to contain_apt__source('icinga-snapshot-builds').with('ensure' => 'present') }
          it { is_expected.to contain_apt__source('netways-extras-release').with('ensure' => 'present') }
        end

        if facts[:os]['family'] == 'RedHat'
          it { is_expected.not_to contain_yumrepo('icinga-stable-release') }
          it { is_expected.to contain_yumrepo('icinga-snapshot-builds').with('enabled' => 1) }
          it { is_expected.to contain_yumrepo('netways-extras-release').with('enabled' => 1) }
        end

        if facts[:os]['family'] == 'Suse'
          it { is_expected.not_to contain_zypprepo('icinga-stable-release') }
          it { is_expected.to contain_zypprepo('icinga-snapshot-builds').with('enabled' => 1) }
        end
      end

      case facts[:os]['family']
      when 'RedHat'
        context 'with manage_epel => false, manage_powertools => false' do
          let(:params) do
            {
              manage_epel: false,
              manage_powertools: false,
            }
          end

          it { is_expected.not_to contain_yumrepo('epel') }
          it { is_expected.not_to contain_yumrepo('powertools') }
        end

        context 'with manage_epel => true, manage_powertools => true, manage_crb => true' do
          let(:params) { { manage_epel: true, manage_powertools: true, manage_crb: true } }

          if facts[:os]['name'] ==  'Fedora' || facts[:os]['name'] == 'OracleLinux'
            it { is_expected.not_to contain_yumrepo('epel') }
            it { is_expected.not_to contain_yumrepo('powertools') }
          else
            it { is_expected.to contain_yumrepo('epel').with('enabled' => 1) }
          end

          if facts[:os]['name'] == 'CentOS'
            if Integer(facts[:os]['release']['major']) == 8
              it { is_expected.to contain_yumrepo('powertools').with('enabled' => 1) }
            elsif Integer(facts[:os]['release']['major']) > 8
              it { is_expected.to contain_yumrepo('crb').with('enabled' => 1) }
            end
          end
        end

      when 'Debian'
        context 'with configure_backports => false' do
          let(:params) { { configure_backports: false } }

          it { is_expected.not_to contain_class('apt::backports') }
        end

        context 'with configure_backports => true' do
          let(:params) { { configure_backports: true } }

          it { is_expected.to contain_class('apt::backports') }
        end

      when 'Suse'

        context 'with manage_server_monitoring => false' do
          let(:params) { { manage_server_monitoring: false } }

          it { is_expected.not_to contain_zypprepo('server_monitoring') }
        end

        if facts[:os]['name'] == 'SLES'
          context 'with manage_server_monitoring => true' do
            let(:params) { { manage_server_monitoring: true } }

            it { is_expected.to contain_zypprepo('server_monitoring').with('enabled' => 1) }
          end
        end

      else
        context 'unsupported platform' do
          it { is_expected.to compile.and_raise_error(%r{not supported}) }
        end
      end
    end
  end
end
