class ssh::server (
  Enum['low','medium','high']
    $security_level = 'medium',
  Variant[Enum['present', 'latest', 'absent'],Pattern[/\d+\.\d*\.?\d*/]]
    $version        = 'present',
) {
  package { 'openssh-server':
    ensure => $version,
  }

  case $security_level {
    'low': {
      notice('This is an insecure setup, only to be used in development')

      firewall { 'allow_all':
        proto  => 'all',
        action => 'accept',
      }
    },
    'medium': {
      firewall { 'allow_some':
        dport  => [80, 443, 22],
        proto  => 'tcp',
        action => 'accept',
      }
    },
    'strict': {
      $sources = hiera('ssh::server::sources',[])
      
      firewall { 'allow_few':
        dport  => [80, 443, 22],
        proto  => 'tcp',
        source => $sources,
        action => 'accept',
      }
    }
  }
}