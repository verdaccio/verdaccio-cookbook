# Verdaccio Cookbook

[![CK Version](http://img.shields.io/cookbook/v/verdaccio.svg)](https://supermarket.getchef.com/cookbooks/verdaccio) [![Build Status](https://travis-ci.org/kgrubb/verdaccio-cookbook.svg?branch=master)](https://travis-ci.org/kgrubb/verdaccio-cookbook)

[Verdaccio Project](https://github.com/verdaccio/verdaccio/)

[Original Sinopia cookbook](https://github.com/BarthV/sinopia-cookbook)

## Description

Verdaccio is a fork of sinopia. It is a private/caching npm repository server.

It allows you to have a local npm registry with zero configuration. You don't have to install and replicate an entire CouchDB database. Verdaccio keeps its own small database and, if a package doesn't exist there, it asks npmjs.org for it keeping only those packages you use.

## Supported Platforms

Tested on:

* Ubuntu 12.04
* Ubuntu 14.04
* Centos 6
* Centos 7

# Usage

Include `verdaccio` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[verdaccio::default]"
  ]
}
```

### chef-mailcatcher::default
- Configures verdaccio folders (in /etc, /var & /var/log)
- Installs node + npm from the official repo at the latest version
- Creates a passwordless verdaccio user who will run the service
- Installs the latest version of verdaccio from npmjs.org
- Configures log rotation to 30d
- Configures and starts verdaccio service

### Default Configuration
* Verdaccio will bind to `127.0.0.1:4873`, so you probably need to setup a web frontend.
* Access to the npm service is allowed to everyone.
* All desired packages are cached from https://registry.npmjs.org/
* A single npm account is provisionned to publish private packages with :
 * login : `admin`
 * passw : `admin`

# Attributes
Every single Verdaccio configuration item can be managed from node attributes.
Default values are specified each time.

## System Configuration

| Key | Type | Description | Default |
|:----|:-----|:------------|:--------|
| ['verdaccio']['user'] | String | The default user running verdaccio | verdaccio |
| ['verdaccio']['confdir'] | String | The config.yaml file location | /etc/verdaccio |
| ['verdaccio']['datadir'] | String | The verdaccio cache & private stores location | /var/lib/verdaccio |
| ['verdaccio']['logdir'] | String | The verdaccio.log file location | /var/log/verdaccio |
| ['verdaccio']['logdays'] | Integer | The log retention policy (days) | 30 |
| ['verdaccio']['loglevel'] | String | The log level. Can be `trace`, `debug`, `info`, `http`, `warn`, `error`, or `fatal` | warn |

## Verdaccio Global Configuration

| Key | Type | Description | Default |
|:----|:-----|:------------|:--------|
| ['verdaccio']['version'] | String | The verdaccio npm package version. Use `nil` for latest | nil |
| ['verdaccio']['admin']['pass'] | String | The verdaccio admin account clear password | admin |
| ['verdaccio']['public_url'] | String | The verdaccio rewrite url, url prefix for provided links | nil |
| ['verdaccio']['timeout'] | Integer | The cached repo timeout in ms | 30000 |
| ['verdaccio']['maxage'] | Integer | The verdaccio metadata cache max age in sec | 120 |
| ['verdaccio']['max_body_size'] | String | The maximum size of uploaded json document, software default is 1mb | nil |

## Users and Permissions

No users are created by default.

* You can set user list with a hash under `default['verdaccio']['users']`, you need to specify a password for each user
* You can give admin permissions to a specific user with `user['admin'] = true` hash

Example:
```ruby
node['verdaccio']['users']['bob']['pass'] = 'incredible'
node['verdaccio']['users']['bob']['admin'] = true

node['verdaccio']['users']['andy']['pass'] = 'toys'
node['verdaccio']['users']['andy']['admin'] = true

node['verdaccio']['users']['woody']['pass'] = 'buzz'
```

## NPM Registry

You can store a list of available npm repositories in `node['verdaccio']['repos']` following {'name' => 'url'} syntax.

Default hash is loaded with official npmjs repo : `default['verdaccio']['repos'] = {'npmjs' => 'https://registry.npmjs.org/'}`

Example :
```ruby
node['verdaccio']['repos'] = {
  'npmjs' => 'https://registry.npmjs.org/', # official npmjs repo
  'myrepo' => 'https://myrepo.local/',
  'other' => 'https://third-party-repo.com'
}
```

`node['verdaccio']['mainrepo']` : (npmjs) Caching repository name selected from available repos list

## Filters

- `default['verdaccio']['strict_access']` : When set to `true`, this only allow admin and admin users to access verdaccio repos, default is `false`
- You can define access & publish filters based on package name under `default['verdaccio']['filters']`
- Filter format is an Array with one Hash for one rule  
- Wildcard is accepted in the filter name rule
- Access can be provided to :
 * Default (all)
 * Specified available users : `['user1', 'user2']`
 * admin account + all admin user : '@admins'
- publish can be provided to :
 * Default (admin account only)
 * Specified available users + admin : `['user1', 'user2']`
 * admin account + all admin user : '@admins'
- Storage value is the name of the folder where filtered packages will be set.

Example :
```ruby
node['verdaccio']['filters'] = [
  {
    'name' => 'private-*',
    'storage' => 'private-repo'
  },
  {
    'name' => 'admin-*',
    'access' => ['andy', 'woody']
  },
  {
    'name' => 'test-*',
    'access' => '@admins'
  }
]
```

## Logging

This cookbook is reusing specific logging format of Verdaccio :

```
type: file | stdout | stderr
level: trace | debug | info | http (default) | warn | error | fatal

{type: 'file', path: 'verdaccio.log', level: 'debug'},

parameters for stdout and stderr: format: json | pretty
{type: 'stdout', format: 'pretty', level: 'debug'}
```

You can add as much logger as you want (including '{}') in `default['verdaccio']['logs']` Array

Default value is :
```ruby
node['verdaccio']['logs'] = [
  "{type: file, path: '/var/log/verdaccio/verdaccio.log', level: warn}"
]
```

## Proxy

See `attributes/default.rb` to view how to configure `node['verdaccio']['use_proxy']` and `node['verdaccio']['proxy']`.

## NPM

See `attributes/default.rb` to view Node & npm install options (version, source/package, ...)

# Recipes

`verdaccio::default` recipe includes :
- `verdaccio::users` : creates users
- `verdaccio::verdaccio` : install verdaccio, directories, conf and start service

# Testing

Verdaccio cookbook is bundled with a Vagrantfile. If you have virtualbox and vagrant ready, just fire a `vagrant up` and this will setup a box running Verdaccio and listening 0.0.0.0:4873. Port 4873 is forwaded to your 127.0.0.1:4873 for test purposes.

# License and Authors

Authors: Barthelemy Vessemont (<bvessemont@gmail.com>), Keli Grubb (<keligrubb324@gmail.com>)

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
