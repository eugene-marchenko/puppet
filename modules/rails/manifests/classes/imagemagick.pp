class rails::imagemagick {

        netinstall { 'imagemagick':
                source_path         => 'ftp://ftp.imagemagick.org/pub/ImageMagick',
                source_filename     => 'ImageMagick-6.6.9-10.tar.gz',
                extracted_dir       => 'ImageMagick-6.6.9-10',
                destination_dir     => '/tmp/',
                postextract_command => './configure --with-perl=yes --with-jpeg=yes --with-magick-plus-plus=yes  --with-png=yes --with-xml=yes --with-zlib=yes; make; make install',
        }

}

