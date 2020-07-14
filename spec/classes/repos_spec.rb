# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::repos' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      context 'with defaults' do
        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_apt__source('icinga-stable-release').with('ensure' => 'present') }
          it { is_expected.to contain_apt__source('icinga-testing-builds').with('ensure' => 'absent') }
          it { is_expected.to contain_apt__source('icinga-snapshot-builds').with('ensure' => 'absent') }

          case os_facts[:operatingsystem] == 'Debian'
          when 'Debian'
            if Integer(os_facts[:operatingsystemmajrelease]) < 10
              it { is_expected.to contain_class('apt::backports') }
            else
              it { is_expected.not_to contain_class('apt::backports') }
            end
          when 'Ubuntu'
            if Integer(os_facts[:operatingsystemmajrelease]) < 18
              it { is_expected.to contain_class('apt::backports') }
            else
              it { is_expected.not_to contain_class('apt::backports') }
            end
          end

        when 'RedHat'
          it { is_expected.to contain_yumrepo('icinga-stable-release').with('enabled' => 1) }
          it { is_expected.to contain_yumrepo('icinga-testing-builds').with('enabled' => 0) }
          it { is_expected.to contain_yumrepo('icinga-snapshot-builds').with('enabled' => 0) }
          case os_facts[:operatingsystem]
          when 'Fedora'
            it { is_expected.not_to contain_yumrepo('epel') }
          else
            if Integer(os_facts[:operatingsystemmajrelease]) < 8
              it { is_expected.to contain_yumrepo('epel').with('enabled' => 1) }
            else
              it { is_expected.to contain_yumrepo('epel').with('enabled' => 0) }
            end
          end

        when 'Suse'
          it { is_expected.to contain_zypprepo('icinga-stable-release').with('enabled' => 1) }
          it { is_expected.to contain_zypprepo('icinga-testing-builds').with('enabled' => 0) }
          it { is_expected.to contain_zypprepo('icinga-snapshot-builds').with('enabled' => 0) }
        end
      end

      context 'with manage_stable => false, manage_testing => true' do
        let(:params) { { manage_stable: false, manage_testing: true } }

        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_apt__source('icinga-stable-release').with('ensure' => 'absent') }
          it { is_expected.to contain_apt__source('icinga-testing-builds').with('ensure' => 'present') }
        when 'RedHat'
          it { is_expected.to contain_yumrepo('icinga-stable-release').with('enabled' => 0) }
          it { is_expected.to contain_yumrepo('icinga-testing-builds').with('enabled' => 1) }
        when 'Suse'
          it { is_expected.to contain_zypprepo('icinga-stable-release').with('enabled' => 0) }
          it { is_expected.to contain_zypprepo('icinga-testing-builds').with('enabled' => 1) }
        end
      end

      context 'with manage_stable => false, manage_nightly => true' do
        let(:params) { { manage_stable: false, manage_nightly: true } }

        case os_facts[:osfamily]
        when 'Debian'
          it { is_expected.to contain_apt__source('icinga-stable-release').with('ensure' => 'absent') }
          it { is_expected.to contain_apt__source('icinga-snapshot-builds').with('ensure' => 'present') }
        when 'RedHat'
          it { is_expected.to contain_yumrepo('icinga-stable-release').with('enabled' => 0) }
          it { is_expected.to contain_yumrepo('icinga-snapshot-builds').with('enabled' => 1) }
        when 'Suse'
          it { is_expected.to contain_zypprepo('icinga-stable-release').with('enabled' => 0) }
          it { is_expected.to contain_zypprepo('icinga-snapshot-builds').with('enabled' => 1) }
        end
      end

      case os_facts[:osfamily]
      when 'RedHat'
        context 'with manage_epel => true' do
          let(:params) { { manage_epel: true } }

          case os_facts[:operatingsystem]
          when 'Fedora'
            it { is_expected.not_to contain_yumrepo('epel') }
          else
            it { is_expected.to contain_yumrepo('epel').with('enabled' => 1) }
          end
        end
      when 'Debian'
        context 'with configure_backports => true' do
          let(:params) { { configure_backports: true } }

          it { is_expected.to contain_class('apt::backports') }
        end
      end
    end
  end
end
