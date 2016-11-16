notify { 'test message': message => "test ${facts['hostname']} message", }
