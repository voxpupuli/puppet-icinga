function icinga::prepare_web(String $icingamod) {

  if !defined('$icinga::prepare_web') or ! $icinga::prepare_web {
    warning("To call plugin icingacli to monitor ${icingamod} set icinga::prepare_web to true!\nOr add the Icinga user to group icingaweb2 by hand and RESTART icinga2.")
  }

}
