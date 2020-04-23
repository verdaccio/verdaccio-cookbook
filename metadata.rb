# frozen_string_literal: true

name 'verdaccio'
maintainer 'Keli Grubb'
maintainer_email 'keligrubb324@gmail.com'
license 'Apache-2.0'
description 'Install a verdaccio NPM server (cache & private repo)
See : https://github.com/verdaccio/verdaccio/'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'
source_url 'https://github.com/verdaccio/verdaccio-cookbook'
issues_url 'https://github.com/verdaccio/verdaccio-cookbook/issues'
chef_version '>= 12'

supports 'ubuntu', '>= 12.04'
supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'amazon'

depends 'apt'
depends 'nodejs'
depends 'user'
depends 'logrotate'
