notify { 'test message': message => "Custom fact is ${facts['custom_fact']} message", }
