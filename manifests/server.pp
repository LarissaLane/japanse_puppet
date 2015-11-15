class ssh::server (
  Enum['低','中','高']
    $セキュリティ・レベル = '中',
  Variant[Enum['ある', '最新', '不在'],Pattern[/\d+\.\d*\.?\d*/]]
    $バージョン        = 'ある',
) {
  package { 'openssh-サーバー':
    ensure => $バージョン,
  }

  case $セキュリティ・レベル {
    '低': {
      notice('This is an insecure setup, only to be used in development')

      firewall { '000 allow_all':
        proto  => 'all',
        action => 'accept',
      }
    }
    '中': {
      firewall { '000 allow_some':
        dport  => [80, 443, 22],
        proto  => 'tcp',
        action => 'accept',
      }
    }
    '高': {
      $sources = hiera('ssh::server::sources',[])
      
      firewall { '000 allow_few':
        dport  => [80, 443, 22],
        proto  => 'tcp',
        source => $sources,
        action => 'accept',
      }
    }
  }
}