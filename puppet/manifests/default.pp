Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }  

stage { 'first': 
  before => Stage['main'],
}

class { 'ruby':
  stage               => first,
  version             => '1.9.3-p392',
  compile_from_source => true,
}

exec { 'ruby-install-compass':
  command => 'gem install compass',
  unless  => 'which compass',
}

class prepare {
  class { 'apt': }
  apt::ppa { 'ppa:chris-lea/node.js': }
}
include prepare
 
package {'nodejs': ensure => present, require => Class['prepare'],}
 
package {'phantomjs':
  ensure   => present,
  provider => 'npm',
  require  => Package['nodejs'],
}

package {'grunt-cli':
  ensure   => present,
  provider => 'npm',
  require  => Package['nodejs'],
}

package {'bower':
  ensure   => present,
  provider => 'npm',
  require  => Package['nodejs'],
}

file { "/etc/profile.d/phantomjs_path.sh": 
  content => 'export PHANTOMJS_BIN="/usr/bin/phantomjs"'
}