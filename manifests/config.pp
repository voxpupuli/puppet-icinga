# @summary
#   Class to inject additional config objects via your manifests.
#   Applied only if `icinga::config_server` is set for dynamically config.
#
# @param objects
#   Additional objects. Merged with icinga::objects and overriden by it.
#
class icinga::config (
  Hash[String[1], Hash] $objects = {},
) {
}
