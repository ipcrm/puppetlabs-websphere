### Type: `websphere_app`

Manages the deployment of applications onto the cluster

#### Example

```puppet
websphere_app{'HelloWorld':
  ensure          => present,
  appsource       => '/vagrant/ibm/apps/helloworld.ear',
  cell            => 'CELL_01',
  cluster         => 'MyCluster01',
  user            => 'websphere',
  profile_base    => '/opt/IBM/WebSphere/AppServer/profiles',
  dmgr_profile    => 'PROFILE_DMGR_01',
  webmodule       => "Hello, World Application",
  webmodule_uri   => "helloworld.war,WEB-INF/web.xml",
  webmodule_vhost => "default_host"
}
```

#### Parameters

##### `ensure`

Valid values: `present`, `absent`

Defaults to `present`.  Sets whether or not the application should be deployed/running
in the cluster.

##### `appsource`

Required.
Set the filesystem path to the war or ear file to be deployed

##### `cell`

Required.
Sets the name of the Websphere Cell

##### `cluster`

Required.
Sets the name of the cluster to deploy to

##### `webmodule`

Required.
Sets the name of the application in the cluster

##### `webmodule_uri`

Required.
Sets the URI for the application (Example helloworld.war,WEB-INF/web.xml)

##### `webmodule_vhost`

Required.
Sets the virtual host to use.  Must already exist.

##### `dmgr_profile`

Required. The name of the DMGR profile to create this application server under.

Examples: `PROFILE_DMGR_01` or `dmgrProfile01`

##### `profile_base`

Required. The full path to the profiles directory where the `dmgr_profile` can
be found.  The IBM default is `/opt/IBM/WebSphere/AppServer/profiles`

##### `user`

Required. The user to run the `wsadmin` command as. Defaults to "root"

##### `wsadmin_user`

Optional. The username for `wsadmin` authentication if security is enabled.

##### `wsadmin_pass`

Optional. The password for `wsadmin` authentication if security is enabled.
