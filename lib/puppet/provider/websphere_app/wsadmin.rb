# Provider for managing websphere application deployments
#
require 'puppet/provider/websphere_helper'

Puppet::Type.type(:websphere_app).provide(:wsadmin, :parent => Puppet::Provider::Websphere_Helper) do

  def exists?
    cmd = <<-EOT.gsub(/^\s+/, "")
      AdminApp.getDeployStatus('#{resource[:appname]}')
    EOT

    self.debug "Querying Deployment Manager for installed apps: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user], :failonfail => false)
    self.debug result

    return true if result.exitstatus == 0
  end

  def create
    cmd = <<-EOT.gsub(/^\s+/, "")
      args = [
        '-reloadEnabled',
        '-reloadInterval 0',
        '-cell #{resource[:cell]}',
        '-cluster #{resource[:cluster]}',
        '-appname #{resource[:appname]}',
        "-MapWebModToVH [[\'#{resource[:webmodule]}\' \'#{resource[:webmodule_uri]}\' \'#{resource[:webmodule_vhost]}\' ]]",
      ];
      AdminApp.install('#{resource[:appsource]}', args)
      AdminConfig.save();
    EOT

    self.debug "Installing new app with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user])
    self.debug result

    sync_app
    start_app
  end

  def destroy
    stop_app
    uninstall_app
  end

  def sync_app
    cmd = <<-EOT.gsub(/^\s+/, "")
      dm=AdminControl.queryNames('type=DeploymentManager,*');
      AdminControl.invoke(dm, 'syncActiveNodes', 'true');
    EOT

    self.debug "Syncing nodes with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user], :failonfail => true)
    self.debug result
  end

  def start_app
    cmd = <<-EOT.gsub(/^\s+/, "")
      AdminApplication.startApplicationOnCluster('#{resource[:appname]}','#{resource[:cluster]}');
      AdminConfig.save()

    EOT

    self.debug "Starting application with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user], :failonfail => true)
    self.debug result 
  end

  def stop_app
    cmd = <<-EOT.gsub(/^\s+/, "")
      AdminApplication.stopApplicationOnCluster('#{resource[:appname]}','#{resource[:cluster]}');
      AdminConfig.save();

    EOT

    self.debug "Stopping application with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user], :failonfail => false)
    self.debug result 
  end

  def uninstall_app
    cmd = <<-EOT.gsub(/^\s+/, "")
      AdminApp.uninstall('#{resource[:appname]}');
      AdminConfig.save()
    EOT

    self.debug "Uninstalling application with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user], :failonfail => true)
    self.debug result 
  end

  def is_ready
    cmd = <<-EOT.gsub(/^\s+/, "")
      AdminApp.isAppReady('#{resource[:appname]}')
    EOT

    self.debug "Checking if application is ready with command: #{cmd}"
    result = wsadmin(:file => cmd, :user => resource[:user])
    self.debug result 

    return true if result.include? 'true'
  end

  def flush
    #Do Nothing
  end 
end
