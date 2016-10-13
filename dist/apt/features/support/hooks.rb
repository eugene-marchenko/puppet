Before do
  # adjust local configuration like this
  @puppetcfg['confdir'] = File.join(File.dirname(__FILE__), '..')
  @puppetcfg['manifest'] = File.join(@puppetcfg['confdir'], 'manifests', 'site.pp')
  @puppetcfg['modulepath']  = File.join(@puppetcfg['confdir'],  '..', '..')

  # adjust facts like this
  @facts["architecture"] = "i386"
  @facts["lsbdistcodename"] = "natty"
  @facts["lsbdistdescription"] = "Ubuntu 11.04"
  @facts["lsbdistrelease"] = "11.04"
  @facts["lsbmajdistrelease"] = "11"
end
