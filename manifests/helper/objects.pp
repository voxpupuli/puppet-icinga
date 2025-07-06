# @summary
#   Realize or export Icinga objects.
#
# @api private
#
define icinga::helper::objects (
  Hash[String[1], Hash]                $objects,
  Stdlib::Absolutepath                 $target,
  Variant[Array[String[1]], String[1]] $export,
) {
  assert_private()
  require icinga::config

  deep_merge($icinga::config::objects, $objects).each |String $type, Hash $objs| {
    ensure_resources(
      downcase("icinga2::object::${type}"),
      $objs.reduce({}) |$memo, $obj| {
        if $obj[1]['target'] {
          $memo + { $obj[0] => $obj[1] + { 'export' => $export } }
        } else {
          $memo + { $obj[0] => $obj[1] + { 'export' => $export, 'target' => $target } }
        }
      }
    )
  }
}
