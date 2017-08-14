class typo3::apache () inherits typo3::params
{
  $php_path = "/etc/opt/rh/$php_version"

  package { $php_packages: 
    ensure => present,
  }

  service {"$apache_version-httpd":
    ensure  => running,
    enable  => true,
    require => Package[$php_packages],    
  }

  file_line { 'php max_execution_time':
    ensure => present,
    path   => "$php_path/php.ini",
    line   => "max_execution_time = $php_max_execution_time",
    match  => '^max_execution_time\ \=',
    notify => Service["$apache_version-httpd"],
  }  

  file_line { 'php max_input_vars':
    ensure => present,
    path   => "$php_path/php.ini",
    line   => "max_input_vars = $php_max_input_vars",
    match  => '^max_input_vars\ \=',
    notify => Service["$apache_version-httpd"],
  }
}
