class frr::repo (
  String $version = $frr::repo_version,
  String $template = 'frr/yum/repo.epp',
) inherits frr {
  case $facts['os']['family'] {
    'RedHat': {
      $gpg_key_name = 'RPM-GPG-KEY-FRR'
      $gpg_key_path = "/etc/pki/rpm-gpg/${gpg_key_name}"
      $repo_path = "/etc/yum.repos.d/${version}.repo"

      file { $gpg_key_path:
        source => "puppet:///modules/frr/${gpg_key_name}",
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        before => File[$repo_path],
      }

      $os_maj = $facts['os']['release']['major']

      # use a template so that all repos can be in one file
      # if we use the yumrepo resource, each repo goes into a different file
      file { $repo_path:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp($template, {
          repos => {
            'frr' => {
              name => "FRRouting Packages for Enterprise Linux 8 - \$basearch",
              baseurl => "https://rpm.frrouting.org/repo/el${os_maj}/frr",
              enabled => '1',
              gpgcheck => '1',
              gpgkey => "file://${gpg_key_path}",
            },
            'frr-RPKI' => {
              name => "FRRouting Packages with RPKI for Enterprise Linux 8 - \$basearch",
              baseurl => "https://rpm.frrouting.org/repo/el${os_maj}/frr-rpki",
              enabled => '0',
              gpgcheck => '1',
              gpgkey => "file://${gpg_key_path}",
            },
            'frr-extras' => {
              name => "FRRouting Dependencies for Enterprise Linux 8 - \$basearch",
              baseurl => "https://rpm.frrouting.org/repo/el${os_maj}/extras",
              enabled => '1',
              gpgcheck => '1',
              gpgkey => "file://${gpg_key_path}",
            },
          }
        }),
      }
    }
  }
}
