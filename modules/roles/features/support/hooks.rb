Before do
  # adjust local configuration like this
  @puppetcfg['confdir'] = File.join(File.dirname(__FILE__), '..')
  @puppetcfg['manifest'] = File.join(@puppetcfg['confdir'], 'manifests', 'site.pp')
  @puppetcfg['modulepath']  = File.join(@puppetcfg['confdir'], '..', '..', ':', @puppetcfg['confdir'], '..', '..', '..', 'dist', ':', @puppetcfg['confdir'], '..', '..', '..', 'site', ':', @puppetcfg['confdir'], '..', '..', '..', 'modules')

  # adjust facts like this
  @facts["puppetversion"] = "2.7.9"
  @facts["architecture"] = "i386"
  @facts["osfamily"] = "Debian"
  @facts["operatingsystem"] = "Ubuntu"
  @facts["lsbdistcodename"] = "precise"
  @facts["lsbdistrelease"] = "12.04"
  @facts["lsbmajdistrelease"] = "12"
  @facts["fqdn"] = "test.local"
  @facts["domain"] = "local"
  @facts["route53_aws_access_key"] = "AAAAAAAAAAAAAAAAAAAAAAAAAAA"
  @facts["route53_aws_secret_access_key"] = "BBBBBBBBBBBBBBBBBBBBBBBBBB"
  @facts["aws_snapshotter_access_key"] = "AAAAAAAAAAAAAAAAAAAAAAAAAAA"
  @facts["aws_snapshotter_secret_key"] = "AAAAAAAAAAAAAAAAAAAAAAAAAAA"
  @facts["ec2_instance_id"] = "i-123456"
  @facts["ec2_placement_availability_zone"] = "us-east-1a"
end
