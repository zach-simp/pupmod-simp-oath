define oath::config::user (
  Array[String]                                      $users,
  Array[String]                                      $token_type,
  Array[Variant[Enum['-','+'], Integer[0,99999999]]] $pin,
  Array[String]                                      $secret_key
) {
  include '::oath::config'
  $_separator = '_'
  $_name = regsubst($name, '/', '_')
  $_token_type = $token_type[0]
  $_pin = $pin[0]
  $_secret_key = $secret_key[0]
  $_users = join($users, $_separator)

  $_content = "${_token_type}\t${_users}\t${_pin}\t${_secret_key}\n"

  concat::fragment { "oath_user_${_name}":
    target  => '/etc/liboath/users.oath',
    content => $_content
  }
}
  
