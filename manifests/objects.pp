# @summary
#   Realize or export Icinga objects.
#
# @api private
#
# @param objects
#   Objects to manage.
#
# @param target
#   File target to write the object to.
#
# @param export
#   Export objects to destination or realize if set to `[]`. 
#
define icinga::objects (
  Hash[String[1], Hash]                $objects,
  Stdlib::Absolutepath                 $target,
  Variant[Array[String[1]], String[1]] $export,
) {
  assert_private()

  $objects.each |String $type, Hash $objs| {
    ensure_resources(
      downcase("icinga2::object::$type"),
      $objs.reduce({}) |$memo, $obj| {
        if $obj[1]['target'] {
          $memo + { $obj[0] => $obj[1] + {
              'export' => $export }}
        } else {
          $memo + { $obj[0] => $obj[1] + {
              'export' => $export,
              'target' => $target }}
        }
      }
    )
  }
}
