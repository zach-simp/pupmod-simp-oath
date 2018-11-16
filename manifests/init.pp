# Full description of SIMP module 'oath' here.
#
# === Welcome to SIMP!
#
# This module is a component of the System Integrity Management Platform, a
# managed security compliance framework built on Puppet.
#
# ---
# *FIXME:* verify that the following paragraph fits this module's characteristics!
# ---
#
# This module is optimally designed for use within a larger SIMP ecosystem, but
# it can be used independently:
#
# * When included within the SIMP ecosystem, security compliance settings will
#   be managed from the Puppet server.
#
# * If used independently, all SIMP-managed security subsystems are disabled by
#   default, and must be explicitly opted into by administrators.  Please
#   review the +trusted_nets+ and +$enable_*+ parameters for details.
#
# @param package_name
#   The name of the oath package
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
