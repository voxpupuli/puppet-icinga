# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::agent' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with ca_server => foo, parent_endpoints => { foobar => { host => 127.0.0.1}}, global_zones => [foobaz]' do
        let(:params) do
          {
            ca_server: 'foo',
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
              'this_zone' => 'NodeName',
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

        it { is_expected.to contain_icinga2__object__zone('foobaz').with({ 'global' => true }) }
      end
    end
  end
end
