# @summary
#   Discover mounted disks.
#
# @return
#   Disks with parameter to monitor.
#
function profile::icinga::disks(
  String         $hostname,
  Array[String]  $filesystems = ['xfs', 'ext4', 'vfat'],
  Array[String]  $drivetypes  = ['Fixed'],
) >> Hash {
  # @param hostname
  #   Icinga object host_name
  #
  # @param filesystems
  #   List of Linux file system types to discover
  #
  # @param drivetypes
  #   List of Windows drive types to discover
  #
  if $facts['kernel'] == 'windows' {
    $facts['drives'].filter |$keys, $values| { $values['drivetype'] in $drivetypes }.keys.reduce({}) |$memo, $disk| {
      $memo + {
        "disk ${disk}" => {
          import           => ['generic-service'],
          host_name        => $hostname,
          command_endpoint => 'host_name',
          check_command    => 'disk-windows',
          vars             => { disk_win_path => $facts['drives'][$disk]['root'] },
        }
      }
    }
  } else {
    $facts['mountpoints'].filter |$keys, $values| { $values['filesystem'] in $filesystems }.keys.reduce({}) |$memo, $disk| {
      $memo + {
        "disk ${disk}" => {
          import           => ['generic-service'],
          host_name        => $hostname,
          command_endpoint => 'host_name',
          check_command    => 'disk',
          vars             => { disk_partitions => $disk },
        }
      }
    }
  }
}
