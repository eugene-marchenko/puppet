class rails::git {

    netinstall { 'git':
        source_path         => 'http://kernel.org/pub/software/scm/git',
        source_filename     => 'git-1.7.5.4.tar.gz',
        extracted_dir       => 'git-1.7.5.4',
        destination_dir     => '/tmp/',
        postextract_command => './configure --with-curl --with-expat; make; make install',
    }

}

