# Full description of SIMP module 'oath' here.
# This module is utilized by other modules in SIMP to download
# TOTP required packages and configure them with sane defaults
# as to make pam_oath.so a functional pam module if used.
#
# @param oath
#   Whether or not to install pam_oath and liboath (if true)
#   or just oathtool (a command-line utility for getting 
#   a 2FA code from a corresponding secret key.
#
# @param pam
#   Whether or not pam is configured on the simp system.
#   Will not install pam_oath without pam being true
#
# @param package_ensure
#   Sets the value for resource => package, key => ensure. 
#
# @param oath_users
#   dict of users processed to create the users.oath file
#   required by the pam_oath.so module. Defaults to hieradata
#   in data/common.yaml. If this is deleted, or set to undef,
#   puppet will not manage users.oath. 
#
# @author Zach
#
class oath (
  Boolean                         $oath                       = simplib::lookup('simp_options::oath', { 'default_value'           => false }),
  Boolean                         $pam                        = simplib::lookup('simp_options::pam', { 'default_value'            => true }),
  Simplib::PackageEnsure          $package_ensure             = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'present'}),
  Optional[Hash]                  $oath_users                 = undef
) { 
  tag 'testing_oath'
  include '::oath::install'
  
  if ($pam == true and $oath == true){
    simplib::assert_metadata($module_name)
    
    include '::oath::pam_oath_install'
    include '::oath::config'
  
    Class[ '::oath::pam_oath_install' ]
    -> Class[ '::oath::config' ]
  }
}
