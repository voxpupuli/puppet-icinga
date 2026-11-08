# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'icinga::repos' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'icinga::repos':
          manage_stable => true,
        }
      PUPPET
    end
  end

  if fact('os.family') == 'Debian'
    describe file('/etc/apt/sources.list.d/icinga-stable-release.list') do
      its(:content) { is_expected.to match %r{packages\.icinga\.com} }
    end
  else
    describe file('/etc/yum.repos.d/icinga-stable-release.repo') do
      its(:content) { is_expected.to match %r{packages\.icinga\.com} }
    end
  end
end
