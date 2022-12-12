# A strict type for a certificate
type Icinga::Certificate =   Struct[{
    cert        => Optional[String],
    key         => Optional[Variant[String, Sensitive[String]]],
    cacert      => Optional[String],
    insecure    => Optional[Boolean],
    cert_file   => Optional[Stdlib::Absolutepath],
    key_file    => Optional[Stdlib::Absolutepath],
    cacert_file => Optional[Stdlib::Absolutepath],
}]
