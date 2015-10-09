include_recipe 'ts_basebox'


node['ts_phpapp']['apps'].each do |item|

	Chef::Log.info("Setting up php application #{item['name']}")

	hostsfile_entry '127.0.0.1' do
		hostname  item['hostname']
		action    :create
	end

	directory "/var/www/#{item['name']}/current" do
		owner 'www-data'
		group 'vagrant'
		mode '0775'
		recursive true
		action :create
	end

	if item['source']['type'] == "git"
		execute 'git clone' do
		  command "git clone #{item['source']['repository']} ."
		  cwd "/var/www/#{item['name']}/current/"
		end

		execute 'git fetch' do
		  command "git fetch"
		  cwd "/var/www/#{item['name']}/current/"
		end

		execute 'git checkout' do
		  command "git checkout #{item['source']['branch']}"
		  cwd "/var/www/#{item['name']}/current/"
		end
	end

	item['deployment'].each do |deploy_command|
		execute "running #{deploy_command}" do
		  command deploy_command
		  cwd "/var/www/#{item['name']}/current/"
		end
	end

	web_app item['name'] do
		server_name item['hostname']
		server_aliases [item['hostname']]
		docroot "/var/www/#{item['name']}/current/web"
		cookbook 'apache2'
	end
end

