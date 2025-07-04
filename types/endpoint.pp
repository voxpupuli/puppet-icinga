# @summary
#   A strict type for Iicnga endpint objects
type Icinga::Endpoint =   Struct[{
    host         => Optional[Stdlib::Host],
    port         => Optional[Stdlib::Port],
    log_duration => Optional[Icinga::Interval],
}]
