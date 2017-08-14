# Installation of Typo3 7/8 on Redhat/Centos 6 with SCL
class typo3 {
  contain typo3::apache
  contain typo3::mariadb
  contain typo3::webapp
}
