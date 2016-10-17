Then /^the augeas config option "([^"]*)" should exist$/ do |name|
  steps %Q{
    Then there should be a resource "Augeas[#{name}]"
  } 
end

Then /^the option should have a value of "([^"]*)"$/ do |value|
  @resource.should have_aug_changes(value)
end
