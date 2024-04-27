# frozen_string_literal: true

require 'spec_helper'

describe 'icinga::cert::files' do
  it { is_expected.not_to be_nil }

  it 'without any cert info' do
    is_expected.to run.with_params(
      'foo',
      '/foobar'
    ).and_return({ 'key' => nil, 'key_file' => nil, 'cert' => nil, 'cert_file' => nil, 'cacert' => nil, 'cacert_file' => nil })
  end

  it 'with key, cert and cacert' do
    is_expected.to run.with_params(
      'foo',
      '/foobar',
      nil,
      nil,
      nil,
      'key',
      'cert',
      'cacert'
    ).and_return({ 'key' => sensitive('key'), 'key_file' => '/foobar/foo.key',
                   'cert' => 'cert', 'cert_file' => '/foobar/foo.crt',
                   'cacert' => 'cacert', 'cacert_file' => '/foobar/foo_ca.crt' })
  end

  it 'with file paths only' do
    is_expected.to run.with_params(
      'foo',
      '/foobar',
      '/foo.key',
      '/foo.crt',
      '/ca.crt',
      nil,
      nil,
      nil
    ).and_return({ 'key' => nil, 'key_file' => '/foo.key', 'cert' => nil, 'cert_file' => '/foo.crt', 'cacert' => nil, 'cacert_file' => '/ca.crt' })
  end

  it 'with all params' do
    is_expected.to run.with_params(
      'foo',
      '/foobar',
      '/foo.key',
      '/foo.crt',
      '/ca.crt',
      'key',
      'cert',
      'cacert'
    ).and_return({ 'key' => sensitive('key'), 'key_file' => '/foo.key', 'cert' => 'cert', 'cert_file' => '/foo.crt', 'cacert' => 'cacert', 'cacert_file' => '/ca.crt' })
  end
end
