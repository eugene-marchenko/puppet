Puppet::Type.type(:a2site).provide(:a2site) do
    desc "Manage Apache 2 virtualhost sites on Debian and Ubuntu"

    optional_commands :encmd => "a2ensite"
    optional_commands :discmd => "a2dissite"

    defaultfor :operatingsystem => [:debian, :ubuntu]

    def create
        encmd resource[:name]
    end

    def destroy
        discmd resource[:name]
    end

    def exists?
        if resource[:name] == 'default'
          sitename = '000-' + resource[:name]
        else
          sitename = resource[:name]
        end
        site= "/etc/apache2/sites-enabled/" + sitename
        File.exists?(site)
    end
end
