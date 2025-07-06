# @summary
#   Helper to export Icinga endpoint object information.
#
# @api private
#
define icinga::helper::endpoint (
  String[1] $zone,
  String[1] $content,
) {
  assert_private()
}
