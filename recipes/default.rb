include_recipe 'ts_basebox'


node['ts_phpapp']['apps'].each do |item|

	Chef::Log.info("Setting up php application #{item['name']}")

	hostsfile_entry '127.0.0.1' do
		hostname  item['hostname']
		action    :create
	end

	directory "/var/www/#{item['name']}/current/web" do
		owner 'www-data'
		group 'vagrant'
		mode '0775'
		recursive true
		action :create
	end

	web_app item['name'] do
		server_name item['hostname']
		server_aliases [item['hostname']]
		docroot "/var/www/#{item['hostname']}/current/web"
		cookbook 'apache2'
	end
end

