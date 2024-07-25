# frozen_string_literal: true

require 'spec_helper'

describe 'icinga' do
  before do
    Puppet::Parser::Functions.newfunction(:assert_private, type: :rvalue) { |args| } # Fake assert_private to not fail
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:params) do
        {
          ca: true,
          this_zone: 'foo',
          zones: {},
          ticket_salt: 'supersecret',
        }
      end

      it { is_expected.to compile }

      case facts[:os]['family']
      when 'RedHat', 'Debian', 'Suse'

        context 'ca => true, this_zone => foo, zones => {}' do
          let(:params) do
            {
              ca: true,
              this_zone: 'foo',
              zones: {},
            }
          end

          it { is_expected.to compile.and_raise_error(%r{expects a String value if a CA is configured}) }
        end

        context 'ca => true, this_zone => foo, zones => {}, ticket_salt => supersecret' do
          it {
            is_expected.to contain_class('icinga2').with(
              {
                confd: false,
                manage_packages: false,
                features: [],
              }
            )
          }

          it { is_expected.to contain_class('icinga2::feature::mainlog').with({ 'ensure' => 'present' }) }
          it { is_expected.to contain_class('icinga2::feature::syslog').with({ 'ensure' => 'absent' }) }
          it { is_expected.to contain_class('icinga2::pki::ca') }

          it {
            is_expected.to contain_class('icinga2::feature::api').with(
              {
                pki: 'none',
                accept_config: true,
                accept_commands: true,
                ticket_salt: 'TicketSalt',
                zones: {},
                endpoints: {},
              }
            )
          }
        end

        context 'ca => false, ca_server => foo, this_zone => foo, zones => { bar => { endpoints => { foobar => { host => 127.0.0.1 }}, parent => foo}}, ticket_salt => supersecret' do
          let(:params) do
            {
              ca: false,
              ca_server: 'foo',
              this_zone: 'foo',
              zones: { bar: { endpoints: { foobar: { host: '127.0.0.1' } }, parent: 'foo' } },
              ticket_salt: 'supersecret',
            }
          end

          it { is_expected.not_to contain_class('icinga2::pki::ca') }

          it {
            is_expected.to contain_class('icinga2::feature::api').with(
              {
                pki: 'icinga2',
                accept_config: true,
                accept_commands: true,
                ticket_salt: 'supersecret',
                ca_host: 'foo',
                zones: {},
                endpoints: {},
              }
            )
          }

          it {
            is_expected.to contain_icinga2__object__zone('bar').with(
              {
                endpoints: ['foobar'],
                parent: 'foo',
              }
            )
          }

          it { is_expected.to contain_icinga2__object__endpoint('foobar').with({ 'host' => '127.0.0.1' }) }
        end

      when 'windows'

        context 'ca => false, this_zone => foo, zones => {}, ticket_salt => supersecret' do
          let(:params) do
            {
              ca: false,
              ca_server: 'foo',
              this_zone: 'foo',
              zones: {},
              ticket_salt: 'supersecret',
            }
          end

          it { is_expected.to compile }

          it {
            is_expected.to contain_class('icinga2').with(
              {
                confd: false,
                manage_packages: true,
                features: [],
              }
            )
          }

          it { is_expected.to contain_class('icinga2::feature::mainlog').with({ 'ensure' => 'present' }) }
          it { is_expected.to contain_class('icinga2::feature::syslog').with({ 'ensure' => 'absent' }) }
          it { is_expected.not_to contain_class('icinga2::pki::ca') }

          it {
            is_expected.to contain_class('icinga2::feature::api').with(
              {
                pki: 'icinga2',
                accept_config: true,
                accept_commands: true,
                ticket_salt: 'supersecret',
                zones: {},
                endpoints: {},
              }
            )
          }
        end

        context 'ca => false, this_zone => foo, zones => {}, logging_type => syslog' do
          let(:params) do
            {
              ca: false,
              this_zone: 'foo',
              zones: {},
              logging_type: 'syslog',
            }
          end

          it { is_expected.to compile.and_raise_error(%r{Only file is supported}) }
        end

      else

        context 'unsupported platform' do
          it { is_expected.to compile.and_raise_error(%r{not supported}) }
        end
      end
    end
  end
end
