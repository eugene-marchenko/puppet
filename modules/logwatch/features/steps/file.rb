Then /^following directories should be created:$/ do |directories|
  directories.hashes.each do |dir|
    steps %Q{
      Then there should be a resource "File[#{dir['name']}]"
      And the state should be "directory"
      And the directory should have standard permissions
    }
  end
end

Then /^following files should be created:$/ do |files|
  files.hashes.each do |file|
    steps %Q{
      Then there should be a resource "File[#{file['name']}]"
      And the state should be "present"
      And the file should have standard permissions
    }
  end
end

Then /^the file should be a symlink to "([^\"]*)"$/ do |target|
  file = file(@resource['name'])
  file.should be_symlink(target)
end

Then /^the file should contain "([^\"]*)"$/ do |text|
  file = file(@resource['name'])
  file.should contain(text)
end

Then /^the file should contain \/([^\"].*)\/$/ do |regex|
  file = file(@resource['name'])
  file.should contain_re(regex)
end

Then /^the (directory|file|script) should have standard permissions$/ do |type|
  case type
  when "directory"
    mode = "0755"
  when "file"
    mode = "0644"
  when "script"
    mode = "0755"
  else
    fail
  end

  steps %Q{
    Then the file should have a "group" of "root"
    And the file should have a "mode" of "#{mode}"
    And the file should have an "owner" of "root"
  }
end

Then /^file "([^\"]*)" should be "([^\"]*)"$/ do |file, state|
  steps %Q{
    Then there should be a resource "File[#{file}]"
    And the state should be "#{state}"
  }
end

Then /^the (file|script) should have restricted permissions$/ do |type|
  case type
  when "file"
    mode = "0600"
  when "script"
    mode = "0700"
  else
    fail
  end

  steps %Q{
    Then the file should have a "group" of "root"
    Then the file should have a "mode" of "#{mode}"
    Then the file should have an "owner" of "root"
  }
end

Then /^there should be a restricted (file|script) "([^\"]*)"$/ do |type,name|
  steps %Q{
    Then there should be a resource "File[#{name}]"
    And the state should be "present"
    And the #{type} should have restricted permissions
  }
end

Then /^there should be a (file|script) "([^\"]*)"$/ do |type, name|
  steps %Q{
    Then there should be a resource "File[#{name}]"
    And the state should be "present"
    And the #{type} should have standard permissions
  }
end
