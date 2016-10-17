# class aws::ec2::ebs::snapshot
node 'aws-ec2-ebs-snapshot-default' {
  class { 'aws::ec2::ebs::snapshot' : }
}

node 'aws-ec2-ebs-snapshot-required-params' {
  class { 'aws::ec2::ebs::snapshot' : accesskey => 'FOO', secretkey => 'BAR' }
}

node 'aws-ec2-ebs-snapshot-from-source-diff-path' {
  class { 'aws::ec2::ebs::snapshot' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/snapshot.pl',
    source    => 'puppet:///modules/aws/ec2/ebs/snapshot.pl'
  }
}

node 'aws-ec2-ebs-snapshot-from-content' {
  class { 'aws::ec2::ebs::snapshot' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'aws-ec2-ebs-snapshot-uninstalled' {
  class { 'aws::ec2::ebs::snapshot' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}

# class aws::ec2::ebs::snapshot::rotation
node 'aws-ec2-ebs-snapshot-rotation-default' {
  class { 'aws::ec2::ebs::snapshot::rotation' : }
}

node 'aws-ec2-ebs-snapshot-rotation-required-params' {
  class { 'aws::ec2::ebs::snapshot::rotation' :
    accesskey => 'FOO',
    secretkey => 'BAR'
  }
}

node 'aws-ec2-ebs-snapshot-rotation-from-source-diff-path' {
  class { 'aws::ec2::ebs::snapshot::rotation' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/rotate.pl',
    source    => 'puppet:///modules/aws/ec2/ebs/snapshot/rotate.pl'
  }
}

node 'aws-ec2-ebs-snapshot-rotation-from-content' {
  class { 'aws::ec2::ebs::snapshot::rotation' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'aws-ec2-ebs-snapshot-rotation-uninstalled' {
  class { 'aws::ec2::ebs::snapshot::rotation' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}

# class aws::ec2::security::group::check
node 'aws-ec2-security-group-check-default' {
  class { 'aws::ec2::security::group::check' : }
}

node 'aws-ec2-security-group-check-required-params' {
  class { 'aws::ec2::security::group::check' :
    accesskey => 'FOO',
    secretkey => 'BAR'
  }
}

node 'aws-ec2-security-group-check-from-source-diff-path' {
  class { 'aws::ec2::security::group::check' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/check.pl',
    source    => 'puppet:///modules/aws/ec2/security/group/check.pl'
  }
}

node 'aws-ec2-security-group-check-from-content' {
  class { 'aws::ec2::security::group::check' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'aws-ec2-security-group-check-uninstalled' {
  class { 'aws::ec2::security::group::check' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}

# class aws::ec2::security::group::export
node 'aws-ec2-security-group-export-default' {
  class { 'aws::ec2::security::group::export' : }
}

node 'aws-ec2-security-group-export-required-params' {
  class { 'aws::ec2::security::group::export' :
    accesskey => 'FOO',
    secretkey => 'BAR'
  }
}

node 'aws-ec2-security-group-export-from-source-diff-path' {
  class { 'aws::ec2::security::group::export' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/export.pl',
    source    => 'puppet:///modules/aws/ec2/security/group/export.pl'
  }
}

node 'aws-ec2-security-group-export-from-content' {
  class { 'aws::ec2::security::group::export' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'aws-ec2-security-group-export-uninstalled' {
  class { 'aws::ec2::security::group::export' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}
