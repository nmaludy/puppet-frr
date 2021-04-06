# Installs FRR
class frr::install (
  Array[String] $packages = $frr::params::packages,
) inherits frr::params {
  package { $packages:
    ensure  => present,
    require => Class['frr::repo'],
  }
}
