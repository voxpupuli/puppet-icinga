# frozen_string_literal: true

require 'spec_helper'

describe('icinga::cert', type: :define) do
  let(:title) { 'foobar' }

  before do
    Puppet::Parser::Functions.newfunction(:assert_private, type: :rvalue) { |args| } # Fake assert_private to not fail
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without key, cert and cacert' do
        let(:params) do
          {
            owner: 'foo',
            group: 'bar',
            args: { key_file: '/key.file', cert_file: '/cert.file', cacert_file: '/cacert.file' },
          }
        end

        it { is_expected.not_to contain_file('/key.file') }
        it { is_expected.not_to contain_file('/cert.file') }
        it { is_expected.not_to contain_file('/cacert.file') }
      end

      context 'with key, cert and cacert' do
        let(:params) do
          {
            owner: 'foo',
            group: 'bar',
            args: { key: 'key', key_file: '/key.file', cert: 'cert', cert_file: '/cert.file', cacert: 'cacert', cacert_file: '/cacert.file' },
          }
        end

        it {
          is_expected.to contain_file('/key.file').with(
            {
              'owner' => 'foo',
              'group' => 'bar',
              'mode'  => '0440',
            }
          ).with_content('key')
        }

        it {
          is_expected.to contain_file('/cert.file').with(
            {
              'owner' => 'foo',
              'group' => 'bar',
              'mode'  => '0640',
            }
          ).with_content('cert')
        }

        it {
          is_expected.to contain_file('/cacert.file').with(
            {
              'owner' => 'foo',
              'group' => 'bar',
              'mode'  => '0640',
            }
          ).with_content('cacert')
        }
      end
    end
  end
end
