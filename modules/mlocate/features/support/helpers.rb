module CucumberPuppet::Helpers

  # Compile catalog for configured testnode.
  def compile_catalog( node = nil )
    Puppet.settings.handlearg("--confdir", @puppetcfg['confdir'])
    if Integer(Puppet.version.split('.').first) >= 3
      Puppet.initialize_settings unless Puppet.settings.global_defaults_initialized?
    else
      Puppet.parse_config
    end
    # reset confdir in case it got overwritten
    @puppetcfg.each do |option,value|
      Puppet.settings.handlearg("--#{option}", value)
    end

    unless node.is_a?(Puppet::Node)
      node = Puppet::Node.new(@facts['hostname'], :classes => @klass)
      node.merge(@facts)
    end

    # Compile our catalog
    begin
      @catalog = Puppet::Resource::Catalog.indirection.find(node.name, :use_node => node)
    rescue NameError
      @catalog = Puppet::Node::Catalog.find(node.name, :use_node => node)
    end

    # XXX could not find this in puppet
    catalog_resources.each do |resource|
      next unless resource[:alias]
      resource[:alias].each do |a|
        # "foo" -> "Package[foo]"
        @aliases["#{resource.type}[#{a}]"] = resource
      end
    end
  end

  def call_function(name, arg)
    Puppet::Parser::Functions.autoloader.loadall
    node = Puppet::Node.new(@facts['hostname'])
    @compiler = Puppet::Parser::Compiler.new(node)
    scope = Puppet::Parser::Scope.new :compiler => @compiler
    scope.send("function_#{name}", arg)
  end

  def file(name)
    catalog_resources.each do |resource|
      return resource if resource.type == 'File' and resource.title == name
    end
  end

  def packages
    packages = catalog_resources.map do |resource|
      resource if resource.type == 'Package'
    end
    packages.compact
  end

end
