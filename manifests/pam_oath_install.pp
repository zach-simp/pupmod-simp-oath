# == Class oath::install
#
# This class is called from oath for install.
#
class oath::pam_oath_install {
  assert_private()
  package { 'liboath': ensure  => $::oath::package_ensure }
  package { 'pam_oath': ensure => $::oath::package_ensure }
  case $facts['os']['name'] {
    'RedHat','CentOS','OracleLinux': {
      if $facts['os']['release']['major'] == '6' {
        file { '/lib64/security/pam_oath.so':
          ensure => 'link',
          target => '/usr/lib64/security/pam_oath.so',
        }
      }
    }
  }
}
