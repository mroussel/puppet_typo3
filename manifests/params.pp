class typo3::params {
  # Typo3
  $typo3_version = '8.7.4'
  $typo3_download_link = "https://get.typo3.org/$typo3_version"

  # Mariadb
  $mariadb_version = 'mariadb55'
  $mariadb_packages = [ "$mariadb_version-mariadb-server" ]

  # Mariadb credentials
  $mariadb_root_password = '1e2ceac5bc5f4104b97184281ab81699'
  $mariadb_typo3_user = 'typo3'
  $mariadb_typo3_password = '3d40a53c51c74df68110fc672ea8a536'
  
  # Apache PHP
  $php_version = 'rh-php70'
  $apache_version = 'httpd24'
  $php_packages = [ 
    "$php_version",
    "$php_version-php",
    "$php_version-php-gd",
    "$php_version-php-json",
    "$php_version-php-mysqlnd",
    "$php_version-php-opcache",
    "$php_version-php-mbstring", 
    "$php_version-php-soap",
  ]
  $php_max_execution_time = '240'
  $php_max_input_vars = '1500'
}