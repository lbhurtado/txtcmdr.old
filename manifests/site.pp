$doc_root        = '/vagrant/web'
$php_modules     = [ 'imagick', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']
$sys_packages    = [ 'build-essential', 'curl', 'vim']
$mysql_host      = 'localhost'
$mysql_db        = 'symfony'
$mysql_user      = 'symfony'
$mysql_pass      = 'password'
$pma_port        = 8000

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'apt-get update':
  command => 'apt-get update',
}

class { 'apt':
  always_apt_update => true,
}

class { 'apache': }

apache::module { 'rewrite': }

apache::vhost { 'default':
  docroot                  => $doc_root,
  directory                => $doc_root,
  directory_allow_override => "All",
  server_name              => false,
  priority                 => '000',
  template                 => 'apache/virtualhost/vhost.conf.erb',
}

class { 'mysql::server': } 

class { 'mysql::client': }

class { 'php': }

package { 'phpmyadmin':
  require => Class[ 'mysql::server' ],
}

apache::vhost { 'phpmyadmin':
  server_name => false,
  docroot     => '/usr/share/phpmyadmin',
  port        => $pma_port,
  priority    => '10',
  require     => Package['phpmyadmin'],
  template    => 'apache/virtualhost/vhost.conf.erb',
}

php::module { $php_modules: }

class { 'smstools': }
