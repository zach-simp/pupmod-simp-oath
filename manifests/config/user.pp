define oath::config::user (
  Array[Pattern[/^\S+(\s+)?$/]]                 $user,
  Pattern[/^HOTP((\/T\d+)?(\/\d+)?)(\s+)?$/]   $token_type,
  Variant[Enum['-','+'], Integer[0,99999999]]  $pin,
  Pattern[/^(..)+(\s+)?$/]                     $secret_key
) {
  include '::oath::config'
  $_separator = '_'
  $_name = strip(regsubst($name, '/', '_'))
  $_token_type = strip($token_type)
  $_secret_key = strip($secret_key)
  $_user = strip(join($user, $_separator))

  $_content = "${_token_type}\t${_user}\t${pin}\t${_secret_key}\n"

  concat::fragment { "oath_user_${_name}":
    target  => '/etc/liboath/users.oath',
    content => $_content
  }
}
  
