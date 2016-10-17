require 'rspec/expectations'

module CucumberPuppet::Matchers
  RSpec::Matchers.define :be_latest do
    match do |resource|
      resource['ensure'] == 'latest'
    end

    failure_message_for_should do |resource|
      "#{resource}\nexpected: ensure => latest\n     got: ensure => #{resource['ensure']}"
    end
  end

  RSpec::Matchers.define :be_symlink do |target|
    match do |resource|
      resource['ensure'] == target or (resource['ensure'] == 'link' and resource['target'] == target)
    end

    failure_message_for_should do |resource|
      """
      #{resource}

      expected: ensure => #{target}

      OR

      expected: ensure => 'link' 
      expected: target => #{target}

      INSTEAD

      got: ensure => #{resource['ensure']}
      got: target => #{resource['target']}

      """
    end
  end

  RSpec::Matchers.define :contain do |expected|
    match do |resource|
      resource['content'].include?(expected) or resource['line'].include?(expected)
    end

    failure_message_for_should do |resource|
      "expected #{resource} to contain\n#{expected}\n"
    end
  end

  RSpec::Matchers.define :contain_re do |regex|
    match do |resource|
      resource['content'] =~ /#{regex}/ or resource['line'] =~ /#{regex}/
    end

    failure_message_for_should do |resource|
      "expected #{resource} to contain\n#{regex}\n"
    end
  end

  RSpec::Matchers.define :have_recipient do |expected|
    match do |resource|
      resource['recipient'] == expected
    end

    failure_message_for_should do |resource|
      """
      expected #{resource}: recipient => #{expected}
      got #{resource}: recipient => #{resource['recipient']}
      """
    end
  end

  RSpec::Matchers.define :have_aug_changes do |changes|
    re_changes = Regexp.escape(changes)
    match do |resource|
      resource['changes'] =~ /#{re_changes}/
    end

    failure_message_for_should do |resource|
      """
      expected #{resource}: changes => #{changes}
      got #{resource}: changes => #{resource['changes']}
      """
    end
  end

end
