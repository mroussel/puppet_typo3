class typo3::webapp () inherits typo3::params
{
  require typo3::apache
  require typo3::mariadb

  $www_root = "/opt/rh/$apache_version/root/var/www"

  File {
    owner => 'apache',
    group => 'apache',
  }

  # https://github.com/TYPO3/TYPO3.CMS/blob/master/INSTALL.md

  archive { "/tmp/typo3_src-$typo3_version.tar.gz":
    ensure        => present,
    extract       => true,
    extract_path  => "$www_root",
    source        => $typo3_download_link,
    creates       => "$www_root/typo3_src-$typo3_version",
    cleanup       => true,
  }

  exec { 'permissions':
    command   => "/bin/chown apache:apache -R $www_root/typo3_src-$typo3_version",
    subscribe => Archive["/tmp/typo3_src-$typo3_version.tar.gz"],
    refreshonly => true,
  } 
  
  file {"$www_root/html/typo3_src":
    ensure => link,
    target => "$www_root/typo3_src-$typo3_version",
    require => Archive["/tmp/typo3_src-$typo3_version.tar.gz"], 
  }

  file {"$www_root/html/typo3":
    ensure => link,
    target => 'typo3_src/typo3',
    require => File["$www_root/html/typo3_src"],
  }

  file {"$www_root/html/index.php":
    ensure => link,
    target => 'typo3_src/index.php',
    require => File["$www_root/html/typo3_src"],
  }

  file {"$www_root/html/.htaccess":
    ensure => present,
    source => "$www_root/html/typo3_src/_.htaccess",
    require => File["$www_root/html/typo3_src"],
  }

  file {"$www_root/html/":
    ensure => directory,
    recurse => true,
    require => File["$www_root/html/typo3_src"],
  }
  
  exec { 'touch FIRST_INSTALL':
    command => "/bin/touch $www_root/html/FIRST_INSTALL; chown apache:apache $www_root/html/FIRST_INSTALL;",
    creates => "$www_root/html/typo3conf/LocalConfiguration.php",
  }
}