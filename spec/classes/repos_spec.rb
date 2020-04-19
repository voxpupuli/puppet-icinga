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
          it { should contain_apt__source('icinga-stable-release').with('ensure' => 'present') }
          it { should contain_apt__source('icinga-testing-builds').with('ensure' => 'absent') }
          it { should contain_apt__source('icinga-snapshot-builds').with('ensure' => 'absent') }
          it { should_not contain_class('apt::backports') }
        when 'RedHat'
          it { should contain_yumrepo('icinga-stable-release').with('enabled' => true) }
          it { should contain_yumrepo('icinga-testing-builds').with('enabled' => false) }
          it { should contain_yumrepo('icinga-snapshot-builds').with('enabled' => false) }
          case os_facts[:operatingsystem]
          when 'Fedora' 
            it { should_not contain_yumrepo('epel') }
          else
            it { should contain_yumrepo('epel').with('enabled' => false) }
          end
          it { should_not contain_package('centos-release-scl') }
        when 'Suse'
          it { should contain_zypprepo('icinga-stable-release').with('enabled' => 1) }
          it { should contain_zypprepo('icinga-testing-builds').with('enabled' => 0) }
          it { should contain_zypprepo('icinga-snapshot-builds').with('enabled' => 0) }
        end
      end

      context 'with manage_stable => false, manage_testing => true' do
        let(:params) { {:manage_stable => false, :manage_testing => true} }
        case os_facts[:osfamily]
        when 'Debian'
          it { should contain_apt__source('icinga-stable-release').with('ensure' => 'absent') }
          it { should contain_apt__source('icinga-testing-builds').with('ensure' => 'present') }
        when 'RedHat'
          it { should contain_yumrepo('icinga-stable-release').with('enabled' => false) }
          it { should contain_yumrepo('icinga-testing-builds').with('enabled' => true) }
        when 'Suse'
          it { should contain_zypprepo('icinga-stable-release').with('enabled' => 0) }
          it { should contain_zypprepo('icinga-testing-builds').with('enabled' => 1) }
        end
      end

      context 'with manage_stable => false, manage_nightly => true' do
        let(:params) { {:manage_stable => false, :manage_nightly => true} }
        case os_facts[:osfamily]
        when 'Debian'
          it { should contain_apt__source('icinga-stable-release').with('ensure' => 'absent') }
          it { should contain_apt__source('icinga-snapshot-builds').with('ensure' => 'present') }
        when 'RedHat'
          it { should contain_yumrepo('icinga-stable-release').with('enabled' => false) }
          it { should contain_yumrepo('icinga-snapshot-builds').with('enabled' => true) }
        when 'Suse'
          it { should contain_zypprepo('icinga-stable-release').with('enabled' => 0) }
          it { should contain_zypprepo('icinga-snapshot-builds').with('enabled' => 1) }
        end
      end

      case os_facts[:osfamily]
      when 'RedHat'
        context 'with manage_epel => true, configure_scl => true' do
          let(:params) { {:manage_epel => true, :configure_scl => true} }
          case os_facts[:operatingsystem] 
          when 'Fedora' 
            it { should_not contain_yumrepo('epel') }
            it { should_not contain_package('centos-release-scl') }
          when 'CentOS', 'Scientific' 
            it { should contain_yumrepo('epel').with('enabled' => true) }
            it { should contain_package('centos-release-scl') }
          else
            it { should contain_yumrepo('epel').with('enabled' => true) }
            it { should_not contain_package('centos-release-scl') }
          end
        end
      when 'Debian'
        context 'with configure_backports => true' do
          let(:params) { {:configure_backports => true} }

          it { should contain_class('apt::backports') }
        end
      end

    end
  end
end
