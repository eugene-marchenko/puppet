module CucumberPuppet::Helpers

  def call_function(name, arg)
    Puppet::Parser::Functions.autoloader.loadall
    node = Puppet::Node.new(@facts['hostname'])
    @compiler = Puppet::Parser::Compiler.new(node)
    scope = Puppet::Parser::Scope.new :compiler => @compiler
    scope.send("function_#{name}", arg)
  end

  def file(name)
    catalog_resources.each do |resource|
    if resource.type == 'File' and resource.title == name
      return resource
    elsif resource.type == 'File_line' and resource.title == name 
      return resource
    end
    end
  end

  def packages
    packages = catalog_resources.map do |resource|
      resource if resource.type == 'Package'
    end
    packages.compact
  end

end
