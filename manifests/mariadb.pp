class typo3::mariadb() inherits typo3::params { 

  $mariadb_root_path = "/opt/rh/$mariadb_version/root"

  package { $mariadb_packages: 
    ensure => present,
  }

  service { "$mariadb_version-mysqld":
    ensure  => running,
    enable  => true,
    require => Package[$mariadb_packages],
  }

  exec { 'Change maria root password':
    provider     => 'shell',
    command      => "scl enable $mariadb_version -- '$mariadb_root_path/usr/bin/mysqladmin' -u root password '$mariadb_root_password'",
    refreshonly => true,
    subscribe    => Package[$mariadb_packages],
  }

  file { '/root/.my.cnf':
    owner => 'root',
    group => 'root',
    mode  => '600',
    content => epp('typo3/my.cnf.epp', {'mariadb_root_password' => $mariadb_root_password}),
  }

  file { "$mariadb_root_path/mariadb_secure_install.sql":
    ensure  => present,
    content => "DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;",
    subscribe   => Package[$mariadb_packages],
  }

  exec { 'maria_secure_install':
    provider    => 'shell',
    command     => "scl enable $mariadb_version -- $mariadb_root_path/usr/bin/mysql --defaults-file=/root/.my.cnf -sfu root < \"$mariadb_root_path/mariadb_secure_install.sql\"",
    require     => File["$mariadb_root_path/mariadb_secure_install.sql", '/root/.my.cnf'],
    subscribe   => Package[$mariadb_packages],
    refreshonly => true,
  }

}
