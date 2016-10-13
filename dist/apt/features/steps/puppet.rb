Given /^a node of class "([^\"]*)"$/ do |klass|
  @klass = klass
end

Given /^a node of class "([^\"]*)" with parameters:$/ do |klass, params|
  parameters = {}
  params.hashes.each do |param|
    if param['value'] == "true"
      parameters[param['name']] = true
    elsif param['value'] == "false"
      parameters[param['name']] = false
    else 
      parameters[param['name']] = param['value']
    end
  end
  @klass = { klass => parameters }
end


Given /^a node named "([^\"]*)"$/ do |name|
  @facts['hostname'] = name
end

Given /^a node in network "([^\"]*)"$/ do |network|
  @facts['network_eth0'] = network
end

Given /^it is a virtual node$/ do
  @facts['processor0'] = "QEMU Virtual CPU version 0.11.0"
end

#Given /^a resource of type "([^\"*)"/ do |type|
#  
#end

When /^I compile the catalog$/ do
  begin
    compile_catalog    
  rescue #Puppet::Error
    @compile_error = true
  end
end

Then /^the compilation should fail$/ do
  fail "compilation was expected to fail. it did not fail." unless @compile_error == true
end

Then /^the [a-z]* should have "([^\"]*)" set to "(false|true)"$/ do |res, bool|
  if bool == "false"
    fail unless @resource[res] == false
  else
    fail unless @resource[res] == true
  end
end

Then /^the [a-z]* should have an? "([^\"]*)" of "([^\"]*)"$/ do |property, value|
  value.gsub!('\n', "\n") # otherwise newlines don't get handled properly
  if @resource[property].is_a?(Puppet::Resource)
    prop = @resource[property].to_s
  elsif @resource[property].kind_of?(Array)
    if value =~ /, /
      value = value.split(", ")
    elsif value =~ /,/
      value = value.split(",")
    else
      value = value.split
    end
    
    prop = @resource[property]
  elsif @resource[property].is_a?(String)
    prop = @resource[property]
  else
    fail "Class #{@resource[property].class} not supported. Please modify steps to accomodate."
  end

  fail "Resource #{@resource} had #{property}='#{@resource[property] ? @resource[property] : "<empty>"}', not '#{value}'" \
    unless prop == value
end

Then /^the [a-z]* should have an? "([^\"]*)" that includes "([^\"]*)"$/ do |property, value|
  value.gsub!('\n', "\n") # otherwise newlines don't get handled properly

  if @resource[property].is_a?(Puppet::Resource)
    prop = @resource[property].to_s
  elsif @resource[property].kind_of?(Array)
    if value =~ /, /
      value = value.split(", ")
    elsif value =~ /,/
      value = value.split(",")
    else
      value = value.split
    end
    
    prop = @resource[property]
  elsif @resource[property].is_a?(String)
    prop = @resource[property]
  else
    fail "Class #{@resource[property].class} not supported. Please modify steps to accomodate."
  end

  fail "Resource #{@resource} had #{property}='#{@resource[property] ? @resource[property] : "<empty>"}', not #{value}" \
    unless @resource[property].match(/#{value}/)
end

Then /^there should be a configuration file "([^\"]*)"$/ do |name|
  steps %Q{
    Then there should be a resource "File[#{name}]"
    And it should be "enabled"
  }
end

Then /^the [a-z]* should notify "([^\"]*)"$/ do |res|
  fail unless @resource["notify"].to_s == res
  steps %Q{
    Then the catalog should contain "#{res}"
  }
end

Then /^the [a-z]* should require "([^\"]*)"$/ do |res|
  req = @resource["require"]
  if req.is_a?(Array)
    found = false
    req.each do |r|
      if r.to_s == res
        found = true
        break
      end
    end
    fail unless found
  else
    fail unless req.to_s == res
  end
  steps %Q{
    Then the catalog should contain "#{res}"
  }
end

Then /^the catalog should contain "([^\"]*)"$/ do |res|
  fail "The catalog does not contain #{res}" unless resource(res)
end

Then /^the state should be "([^\"]*)"$/ do |state|
  fail "Resource #{@resource} has ensure = #{@resource["ensure"]}, not #{state}" \
    unless @resource["ensure"] == state
end

#Then /^there should be a resource "([^\"]*)"$/ do |res|
#  @resource = resource(res)
#  fail unless @resource
#end
Then /^there should be a yum repository "([^\"]*)"$/ do |name|
  steps %Q{
    Then there should be a resource "Yum::Repo[#{name}]"
    And it should be "enabled"
  }
end

Then /^it should be "(enabled|disabled)"$/ do |bool|
  if bool == "enabled"
    fail unless @resource["enabled"] == "1"
  else
    fail unless @resource["enabled"] == "0"
  end
end

Then /^there should not be a resource "([^\"]*)"$/ do |res|
  @resource = resource(res)
  fail "Resource #{res} was defined. oops." unless !@resource
end

Then /^there should be a resource "([^\"]*)"$/ do |res|
  @resource = resource(res)
  fail "Resource #{res} was not defined" unless @resource
end

Then /^class paramater "([^"]*)" should be "([^"]*)"$/ do |var, param|
	fail "variable #{res} undefined!"  unless @resource["#{var}"] == value
end

Then /^print everything please$/ do 
  steps %Q{
    Then print all the resources
    And print all the facts
  }
end

Then /^print all the resources$/ do
    puts "\nResources"
	catalog_resources.each do | entry |
	  puts entry
	  inspection = @catalog.resource(entry.to_s).inspect
	  puts "Inspection: #{@catalog.resource(entry.to_s).inspect}"
	end
end

Then /^print all the facts$/ do
  puts "\nFacts"
  @facts.each do | key, value |
    puts "#{key} - #{value}"
  end
end
