# encoding: utf-8

## System user running verdaccio
default['verdaccio']['user'] = 'verdaccio'

## verdaccio gem version (use nil for latest)
default['verdaccio']['version'] = nil

## verdaccio users configuration
default['verdaccio']['admin']['pass'] = 'admin'

default['verdaccio']['users'] = {}

# default['verdaccio']['users']['bob']['pass'] = 'incredible'
# default['verdaccio']['users']['bob']['admin'] = true

# default['verdaccio']['users']['andy']['pass'] = 'toys'
# default['verdaccio']['users']['andy']['admin'] = true

# default['verdaccio']['users']['woody']['pass'] = 'buzz'

## verdaccio links rewrite URL (url_prefix)
# default['verdaccio']['public_url'] = 'https://my-npm-private-repo.local/'

## Bind address (IP:port format)
# use nil for default (127.0.0.1:4873)
# use ':port' or '0.0.0.0:port' to listen on all interfaces
default['verdaccio']['listen'] = nil

## verdaccio conf directories
# Parents directory MUST exists !
default['verdaccio']['confdir'] = '/etc/verdaccio'
default['verdaccio']['logdir'] = '/var/log/verdaccio'
default['verdaccio']['logdays'] = 30
default['verdaccio']['datadir'] = '/var/lib/verdaccio'
default['verdaccio']['loglevel'] = 'warn'

## NodeJS repo list options
default['verdaccio']['repos'] = {
  'npmjs' => 'https://registry.npmjs.org/' # official npmjs repo
  # 'myrepo' => 'https://myrepo.local/'
}

default['verdaccio']['mainrepo'] = 'npmjs'

default['verdaccio']['timeout'] = nil # 30000 ms
default['verdaccio']['maxage'] = nil # 120 s
default['verdaccio']['max_body_size'] = nil # 1mb

# Restric read access for admins only
default['verdaccio']['strict_access'] = false

default['verdaccio']['use_proxy'] = false
default['verdaccio']['proxy']['http'] = 'http://something.local/'
default['verdaccio']['proxy']['https'] = 'https://something.local/'
default['verdaccio']['proxy']['no_proxy'] = [
  'localhost', '127.0.0.1'
]

## local repos ACL - filters
default['verdaccio']['filters'] = [
  # {
  #   'name' => 'private-*',
  #   'storage' => 'private-repo'
  # },
  # {
  #   'name' => 'admin-*',
  #   'access' => ['andy', 'woody']
  # },
  #
  ## @admin is a special value for admin account + all admin users
  #
  # {
  #   'name' => 'test-*',
  #   'access' => '@admins'
  # }
]

## Logging options
# type: file | stdout | stderr
# level: trace | debug | info | http (default) | warn | error | fatal
#
# parameters for file: name is filename
#  {type: 'file', path: 'verdaccio.log', level: 'debug'},
#
# parameters for stdout and stderr: format: json | pretty
#  {type: 'stdout', format: 'pretty', level: 'debug'},
default['verdaccio']['logs'] = [
  "{type: 'file', path: '#{File.join(node['verdaccio']['logdir'], 'verdaccio.log')}', level: '#{node['verdaccio']['loglevel']}'}"
]
