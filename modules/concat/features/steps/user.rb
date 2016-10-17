Then /^user "([^\"]*)" should be in groups? "([^\"]*)"$/ do |user, groups|
  steps %Q{
    Then there should be a resource "User[#{user}]"
    And the user should be in groups "#{groups}"
  }
end

Then /^the user should be in groups "([^\"]*)"$/ do |groups|
  g = @resource["groups"]
  g_s = g
  if g.is_a?(Array)
    g_s = g.join(' ')
  end
  fail unless g_s == groups
end

Then /^user "([^\"]*)" should be "([^\"]*)"$/ do |user, state|
  steps %Q{
    Then there should be a resource "User[#{user}]"
    And the state should be "#{state}"
  }
end

Then /^group "([^\"]*)" should be "([^\"]*)"$/ do |group, state|
  steps %Q{
    Then there should be a resource "Group[#{group}]"
    And the state should be "#{state}"
  }
end

Then /^key "([^\"]*)" should be "([^\"]*)"$/ do |key, state|
  steps %Q{
    Then there should be a resource "Ssh_authorized_key[#{key}]"
    And the state should be "#{state}"
  }
end

Then /^the [a-z]* should have no "([^\"]*)"$/ do |property|
  fail "Resource #{@resource} had #{property} #{@resource[property]}" unless @resource[property].nil?
end
