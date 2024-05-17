# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::worker' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context "#{os} with ca_server 'foo', zone 'bar', a parent_endpoints 'foobar', global_zones ['foobaz']" do
        let(:params) do
          {
            ca_server: 'foo',
            zone: 'bar',
            parent_endpoints: { 'foobar' => { 'host' => '127.0.0.1' } },
            global_zones: ['foobaz'],
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_class('icinga').with(
            {
              'ca' => false,
              'ca_server' => 'foo',
              'this_zone' => 'bar',
              'zones' => {
                'ZoneName' => {
                  'endpoints' => { 'NodeName' => {} },
                  'parent' => 'main',
                },
                'main' => {
                  'endpoints' => { 'foobar' => { 'host' => '127.0.0.1' } },
                },
              },
              'logging_type' => 'syslog',
            }
          )
        }

        it { is_expected.to contain_class('icinga2::feature::checker') }

        it { is_expected.to contain_icinga2__object__zone('foobaz').with({ 'global' => true }) }
      end

      context "#{os} with zone 'foo' and two workers, logging_type 'syslog', logging_level 'warning'" do
        let(:params) do
          {
            ca_server: 'foo',
            zone: 'foo',
            parent_endpoints: { 'foobar' => { 'host' => '127.0.0.1' } },
            workers: {
              'baz' => { 'endpoints' => { 'foobaz' => { 'host' => '127.0.0.1' } } },
              'out' => { 'endpoints' => { 'outbar' => {} }, 'parent' => 'baz' },
            },
            logging_type: 'syslog',
            logging_level: 'warning',
          }
        end

        it {
          is_expected.to contain_class('icinga').with(
            {
              'ca' => false,
              'ca_server' => 'foo',
              'this_zone' => 'foo',
              'zones' => {
                'ZoneName' => {
                  'parent' => 'main',
                  'endpoints' => { 'NodeName' => {} },
                },
                'main' => {
                  'endpoints' => { 'foobar' => { 'host' => '127.0.0.1' } },
                },
                'baz' => {
                  'parent' => 'foo',
                  'endpoints' => { 'foobaz' => { 'host' => '127.0.0.1' } },
                },
                'out' => {
                  'parent' => 'baz',
                  'endpoints' => { 'outbar' => {} },
                }
              },
              'logging_type' => 'syslog',
              'logging_level' => 'warning',
            }
          )
        }
      end
    end
  end
end
