Then /^the mailalias "([^"]*)" should be created$/ do |name|
  steps %Q{
    Then there should be a resource "Mailalias[#{name}]"
    And the state should be "present"
  }
end

Then /^the mailalias "([^"]*)" should be absent$/ do |name|
  steps %Q{
    Then there should be a resource "Mailalias[#{name}]"
    And the state should be "absent"
  }
end

Then /^the mailalias should be pointed to "([^"]*)"$/ do |recipient|
  @resource.should have_recipient(recipient)
end
