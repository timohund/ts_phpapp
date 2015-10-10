Introduction
============

This cookbook can be used to kickstart a php based webapplication in a Vagrant environment
with only a little manual configuration.


You can configure in your VagrantFile, which vHost should be created and
which git repository will be checked out in to the rootfolder of your php app.
After the checkout the deploy commands that you specify will be applied.

Example:

::

   config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["cookbooks","site-cookbooks"]
      chef.json = {
         'ts_basebox' => {
            'elasticsearch' => {
                'install' => true
            },
            'solr' => {
                'install' => true
            }
         },
        'ts_phpapp' => {
            'apps' => [{
               'name' => 'superkicker',
                'shortname' => 'sk',
                'hostname' => 'superkicker.devbox.local',
                'source' => {
                   'type' => 'git',
                   'repository' => 'https://github.com/timoschmidt/superkicker.git',
                   'branch' => 'master'
                },
                'deployment' => [
                   'composer install',
                   'php app/console doctrine:database:create',
                   'php app/console doctrine:schema:update --force'
                ]
             }]
         }
      }
      chef.add_recipe "ts_phpapp"
   end

::

