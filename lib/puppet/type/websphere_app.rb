require 'pathname'

Puppet::Type.newtype(:websphere_app) do
  @doc = "This manages WebSphere Application Deployment"

  ensurable

  newparam(:appname) do
    isnamevar
    desc <<-EOT
      The name of the application we are deploying
    EOT

    validate do |value|
      unless value =~ /^[-0-9A-Za-z._]+$/
        raise ArgumentError, "Invalid appname #{value}"
      end
    end
  end

  newparam(:dmgr_profile) do
    desc <<-EOT
      Required. The name of the DMGR profile to create this application
      server under.

      Examples: `PROFILE_DMGR_01` or `dmgrProfile01`"
    EOT

    validate do |value|
      unless value =~ /^[-0-9A-Za-z._]+$/
        fail("Invalid dmgr_profile #{value}")
      end
    end
  end

  newparam(:profile_base) do
    desc <<-EOT
      Required. The full path to the profiles directory where the
      `dmgr_profile` can be found.  The IBM default is
      `/opt/IBM/WebSphere/AppServer/profiles`
    EOT

    validate do |value|
      fail("Invalid profile_base #{value}") unless Pathname.new(value).absolute?
    end
  end

  newparam(:appsource) do
    desc <<-EOT
      The path to the application source file (EAR or WAR)
    EOT

    validate do |value|
      unless File.exists?(value)
        raise ArgumentError, "Invalid path #{value}"
      end
    end
  end

  newparam(:cell) do
    desc <<-EOT
      Name of the cell to deploy the application into.
    EOT
    validate do |value|
      unless value =~ /^[-0-9A-Za-z._]+$/
        raise ArgumentError, "Invalid cell name #{value}"
      end
    end
  end

  newparam(:cluster) do
    desc <<-EOT
      Name of the cluster to deploy the application into.
    EOT
    validate do |value|
      unless value =~ /^[-0-9A-Za-z._]+$/
        raise ArgumentError, "Invalid cluster name #{value}"
      end
    end
  end

  newparam(:webmodule) do
    desc <<-EOT
      Name of the webModule included in the War(ie the display-name in your web.xml file)
    EOT
  end

  newparam(:webmodule_uri) do
    desc <<-EOT
      URI to the web.xml (example myapp.war,WEB-INF/web.xml)
    EOT
  end

  newparam(:webmodule_vhost) do
    desc <<-EOT
      Name of the EXISTING vhost name to run the module on
    EOT
    validate do |value|
      unless value =~ /^[-0-9A-Za-z._]+$/
        raise ArgumentError, "Invalid vhost name #{value}"
      end
    end
  end

  newparam(:user) do
    desc "The username for 'wsadmin.sh' to run as"
  end

  newparam(:wsadmin_user) do
    desc <<-EOT
      Optional. The username for `wsadmin` authentication if security is
      enabled.
    EOT
  end

  newparam(:wsadmin_pass) do
    desc <<-EOT
      Optional. The password for `wsadmin` authentication if security is
      enabled.
    EOT
  end

  validate do
    raise(ArgumentError, "Missing parameter appname")         if parameters[:appname].nil?
    raise(ArgumentError, "Missing parameter dmgr_profile")    if parameters[:dmgr_profile].nil?
    raise(ArgumentError, "Missing parameter profile_base")    if parameters[:profile_base].nil?
    raise(ArgumentError, "Missing parameter appsource")       if parameters[:appsource].nil?
    raise(ArgumentError, "Missing parameter cell")            if parameters[:cell].nil?
    raise(ArgumentError, "Missing parameter cluster")         if parameters[:cluster].nil?
    raise(ArgumentError, "Missing parameter webmodule")       if parameters[:webmodule].nil?
    raise(ArgumentError, "Missing parameter webmodule_uri")   if parameters[:webmodule_uri].nil?
    raise(ArgumentError, "Missing parameter webmodule_vhost") if parameters[:webmodule_vhost].nil?
    raise(ArgumentError, "Missing parameter user")            if parameters[:user].nil?
  end
end
