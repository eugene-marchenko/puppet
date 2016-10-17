Then /^logrotate job "([^\"]*)" should be "([^\"]*)"$/ do  |name, state|
  steps %Q{
    Then there should be a resource "Logrotate[#{name}]"
    And the state should be "#{state}"
  }
end
