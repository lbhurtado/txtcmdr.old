# pp file
$app_root        = '/vagrant'
$doc_root        = "$app_root/web"
$sys_packages    = ['build-essential', 'curl', 'vim']
$php_modules     = ['imagick', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']
$mysql_host      = 'localhost'
$mysql_db        = 'symfony'
$mysql_user      = 'symfony'
$mysql_pass      = 'password'
$pma_port        = 8000

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

package { $sys_packages:
  ensure => "installed",
  /*require => Exec['apt-get update'],*/
}

# Configure apache
class { 'apache':
  default_mods        => false,
  default_confd_files => false,
  default_vhost       => false,
  mpm_module          => 'prefork', 
}

include apache::mod::prefork
include apache::mod::rewrite

apache::vhost { $::fqdn:
  port    => '80',
  docroot => $doc_root,
  require => Class[ 'composer' ],
}

apache::vhost { 'phpmyadmin':
  docroot     => '/usr/share/phpmyadmin',
  port        => $pma_port,
  priority    => '10',
  require     => Package[ 'phpmyadmin' ],
}

class { '::apache::mod::php': 
  package_name => 'php',
}

class { 'php': }

php::module { $php_modules: }

txtcmdr::phpini { 'php':
  service => 'httpd',
  value => [ 'date.timezone = "UTC"', 'upload_max_filesize = 8M', 'short_open_tag = 0'],
}

#Configure mysql
class { 'mysql::server':
  root_password => 'strongpassword' 
}

class { 'mysql::bindings':
  php_enable => true
}

package { 'phpmyadmin':
  ensure => 'installed',
  require => Class[ 'mysql::server' ],
}

Firewall <||>

class { 'composer':
  path => $app_root,
  require => [ Class[ 'php' ], Package[ 'curl' ] ],
}

user { 'vagrant':
  ensure => present,
  home => '/home/vagrant',
  managehome => true,
}

class { 'symfony':
  db_name  => $mysql_db,
  db_user  => $mysql_user,
  db_pass  => $mysql_pass,
  require  => User[ 'vagrant'],
}

class { 'smstools': }