name 'verdaccio'
maintainer 'Keli Grubb'
maintainer_email 'keligrubb324@gmail.com'
license 'Apache 2.0'
description 'Install a verdaccio NPM server (cache & private repo)
See : https://github.com/verdaccio/verdaccio/'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.2'
source_url 'https://github.com/kgrubb/verdaccio-cookbook'
issues_url 'https://github.com/kgrubb/verdaccio-cookbook/issues'

supports 'ubuntu', '>= 12.04'
supports 'redhat'
supports 'centos'
supports 'fedora'

depends 'apt'
depends 'nodejs', '~> 2.4'
depends 'user'
depends 'logrotate'
