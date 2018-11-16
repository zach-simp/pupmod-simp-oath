# == Class oath::config
#
# This class is called from oath for service config.
#
class oath::config {
  assert_private()

  file { '/etc/liboath':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    seluser => 'system_u',
    seltype => 'var_auth_t',
  }
  file { '/etc/liboath/exclude_users.oath':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    seluser => 'system_u',
    seltype => 'var_auth_t',
    source  => "puppet:///modules/${module_name}/etc/liboath/exclude_users.oath",
  }
  file { '/etc/liboath/exclude_groups.oath':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    seluser => 'system_u',
    seltype => 'var_auth_t',
    source  => "puppet:///modules/${module_name}/etc/liboath/exclude_groups.oath",
  }

  if $oath::oath_users {
    concat { '/etc/liboath/users.oath':
      owner          => 'root',
      group          => 'root',
      mode           => '0600',
      ensure_newline => true,
      warn           => true,
      seluser        => 'system_u',
      seltype        => 'var_auth_t',
    }
    if $oath::oath_users['defaults'].is_a(Hash) {
      $defaults = $oath::oath_users['defaults']
      $raw_users = $oath::oath_users - 'defaults'
    }
    else {
      $defaults = {}
      $raw_users = $oath::oath_users
    }


    $raw_users.each |$some_user, $options| {
      if $options.is_a(Hash) {
        $args = { 'user' => [$some_user] } + $options
      }
      else {
        $args = { 'user' => [$some_user] }
      }

      oath::config::user {
        default:  *            => $defaults;
        "user_${some_user}": * => $args;
      }
    }
  }
  else {
    warning('No users were specified for the /etc/liboath/users.oath config file! Puppet will not be managing this essential file!')
  }
}
