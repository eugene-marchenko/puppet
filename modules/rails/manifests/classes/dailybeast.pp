class rails::dailybeast {

    exec { 'git_set_global':
        command => '/usr/local/bin/git config --global --add http.sslVerify false',
        creates => '/root/.gitconfig',
    }

    exec { 'git_clone_dailybeast':
        cwd     => '/usr/local/',
        command => '/usr/local/bin/git clone https://ndbwebops:j0j0k0k0@github.com/dailybeast/Daily-Beast-2.0.git',
        onlyif  => 'ls /root/.gitconfig',
    }

}
