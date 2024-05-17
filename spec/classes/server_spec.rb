# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:os]['family']
      when 'Debian'
        let(:icinga2_config_dir) { '/etc/icinga2' }
        let(:icinga2_user) { 'nagios' }
        let(:icinga2_group) { 'nagios' }
      when 'RedHat', 'Suse'
        let(:icinga2_config_dir) { '/etc/icinga2' }
        let(:icinga2_user) { 'icinga' }
        let(:icinga2_group) { 'icinga' }
      end

      context "#{os} with defaults" do
        it { is_expected.to compile.and_raise_error(%r{expects a String value if a CA is configured}) }
      end

      context "#{os} with ticket_salt 'supersecret', global_zones ['foo','bar'], web_api_user 'bar', web_api_pass 'topsecret'" do
        let(:params) do
          {
            ticket_salt: 'supersecret',
            global_zones: %w[foo bar],
            web_api_user: 'bar',
            web_api_pass: 'topsecret'
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_class('icinga').with(
            {
              'ca' => true,
              'this_zone' => 'main',
              'zones' => {
                'ZoneName' => {
                  'endpoints' => { 'NodeName' => {}, },
                },
              },
              'logging_type' => 'syslog',
              'ticket_salt' => 'supersecret',
            }
          )
        }

        it { is_expected.to contain_class('icinga2::feature::checker') }
        it { is_expected.to contain_class('icinga2::feature::notification') }
        it { is_expected.to contain_class('icinga2::feature::mainlog') }

        it {
          is_expected.to contain_file("#{icinga2_config_dir}/zones.d/main").with(
            {
              'ensure' => 'directory',
              'owner' => icinga2_user,
              'group' => icinga2_group,
              'mode' => '0750',
            }
          )
        }

        it { is_expected.to contain_icinga2__object__zone('foo').with('global' => true, 'order' => 'zz') }
        it { is_expected.to contain_icinga2__object__zone('bar').with('global' => true, 'order' => 'zz') }

        it {
          is_expected.to contain_file("#{icinga2_config_dir}/zones.d/foo").with(
            {
              'ensure' => 'directory',
              'owner' => icinga2_user,
              'group' => icinga2_group,
              'mode' => '0750',
            }
          )
        }

        it { is_expected.to contain_icinga2__object__apiuser('bar').with({ 'password' => 'topsecret' }) }
      end

      context "#{os} with ca_server 'foo', ticket_salt 'supersecret' and a colocation_endpoints" do
        let(:params) do
          {
            ca_server: 'foo',
            ticket_salt: 'supersecret',
            colocation_endpoints: { 'bar' => { 'host' => '127.0.0.1' } },
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_class('icinga').with(
            {
              'ca' => false,
              'ca_server' => 'foo',
              'this_zone' => 'main',
              'zones' => {
                'ZoneName' => {
                  'endpoints' => {
                    'NodeName' => {},
                    'bar' => { 'host' => '127.0.0.1' },
                  },
                },
              },
              'logging_type' => 'syslog',
              'ticket_salt' => 'supersecret',
            }
          )
        }
      end

      context "#{os} with ticket_salt 'supersecret', zone 'foo' and two workers, logging_type 'syslog', logging_level 'warning'" do
        let(:params) do
          {
            ticket_salt: 'supersecret',
            zone: 'foo',
            workers: {
              'bar' => { 'endpoints' => { 'foobar' => { 'host' => '127.0.0.1' } } },
              'out' => { 'endpoints' => { 'outbar' => {} }, 'parent' => 'bar' },
            },
            logging_type: 'syslog',
            logging_level: 'warning',
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_class('icinga').with(
            {
              'ca'            => true,
              'this_zone'     => 'foo',
              'zones'         => {
                'ZoneName' => {
                  'endpoints' => { 'NodeName' => {} },
                },
                'bar' => {
                  'parent'    => 'foo',
                  'endpoints' => { 'foobar' => { 'host' => '127.0.0.1' } },
                },
                'out' => {
                  'parent'    => 'bar',
                  'endpoints' => { 'outbar' => {} },
                }
              },
              'logging_type'  => 'syslog',
              'logging_level' => 'warning',
              'ticket_salt'   => 'supersecret',
            }
          )
        }
      end
    end
  end
end
