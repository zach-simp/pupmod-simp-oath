# == Class oath::install
#
# This class is called from oath for install.
#
class oath::install {
  assert_private()
  package { 'oathtool': ensure  => $::oath::package_ensure }
}
